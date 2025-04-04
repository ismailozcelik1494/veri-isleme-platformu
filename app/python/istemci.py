import socket

# İstemci oluşturma
client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
client.connect(("localhost", 12345))

# Sunucuya veri gönder
client.send(b"Merhaba sunucu!")

# Bağlantıyı kapat
client.close()