import socket

# Sunucu oluşturma
server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server.bind(("localhost", 12345))
server.listen()

print("Sunucu başlatıldı, bağlantı bekleniyor...")

# İstemci bağlantısı kabul etme
conn, addr = server.accept()
print("Bağlantı kuruldu:", addr)

# İstemciden gelen veriyi al
data = conn.recv(1024)
print("Alınan veri:", data.decode())

# Bağlantıyı kapat
conn.close()
server.close()