#
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

"""
Change value column type to longblob in xcom table for mysql.

Revision ID: b4078ac230a1
Revises: 8e1c784a4fc7
Create Date: 2024-03-22 14:06:51.185268

"""

from __future__ import annotations

import sqlalchemy as sa
from alembic import op
from sqlalchemy.dialects.mysql import LONGBLOB

# revision identifiers, used by Alembic.
revision = "b4078ac230a1"
down_revision = "8e1c784a4fc7"
branch_labels = None
depends_on = None
airflow_version = "2.9.0"


def upgrade():
    """Apply Change value column type to longblob in xcom table for mysql."""
    conn = op.get_bind()
    if conn.dialect.name == "mysql":
        with op.batch_alter_table("xcom", schema=None) as batch_op:
            batch_op.alter_column("value", type_=sa.LargeBinary().with_variant(LONGBLOB, "mysql"))


def downgrade():
    """Unapply Change value column type to longblob in xcom table for mysql."""
    conn = op.get_bind()
    if conn.dialect.name == "mysql":
        with op.batch_alter_table("xcom", schema=None) as batch_op:
            batch_op.alter_column("value", type_=sa.LargeBinary)
