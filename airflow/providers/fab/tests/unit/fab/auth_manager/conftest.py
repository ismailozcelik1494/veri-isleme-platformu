# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
from __future__ import annotations

import json
import os
from contextlib import contextmanager
from pathlib import Path

import pytest

from airflow.providers.fab.www import app

from tests_common.test_utils.config import conf_vars
from tests_common.test_utils.db import parse_and_sync_to_db
from unit.fab.decorators import dont_initialize_flask_app_submodules


@pytest.fixture(scope="session")
def minimal_app_for_auth_api():
    @dont_initialize_flask_app_submodules(
        skip_all_except=[
            "init_appbuilder",
            "init_api_auth",
            "init_api_auth_provider",
            "init_api_connexion",
            "init_api_error_handlers",
            "init_airflow_session_interface",
            "init_appbuilder_views",
        ]
    )
    def factory():
        with conf_vars(
            {
                (
                    "fab",
                    "auth_backends",
                ): "unit.fab.auth_manager.api_endpoints.remote_user_api_auth_backend,airflow.providers.fab.auth_manager.api.auth.backend.session",
                (
                    "core",
                    "auth_manager",
                ): "airflow.providers.fab.auth_manager.fab_auth_manager.FabAuthManager",
            }
        ):
            _app = app.create_app(enable_plugins=False)
            _app.config["AUTH_ROLE_PUBLIC"] = None
            return _app

    return factory()


@pytest.fixture
def set_auth_role_public(request):
    app = request.getfixturevalue("minimal_app_for_auth_api")
    auto_role_public = app.config["AUTH_ROLE_PUBLIC"]
    app.config["AUTH_ROLE_PUBLIC"] = request.param

    yield

    app.config["AUTH_ROLE_PUBLIC"] = auto_role_public


@pytest.fixture(scope="module")
def dagbag():
    from airflow.models import DagBag

    parse_and_sync_to_db(os.devnull, include_examples=True)
    return DagBag(read_dags_from_db=True)


@pytest.fixture
def configure_testing_dag_bundle():
    """Configure the testing DAG bundle with the provided path, and disable the DAGs folder bundle."""

    @contextmanager
    def _config_bundle(path_to_parse: Path | str):
        bundle_config = [
            {
                "name": "testing",
                "classpath": "airflow.dag_processing.bundles.local.LocalDagBundle",
                "kwargs": {"path": str(path_to_parse), "refresh_interval": 0},
            }
        ]
        with conf_vars({("dag_processor", "dag_bundle_config_list"): json.dumps(bundle_config)}):
            yield

    return _config_bundle
