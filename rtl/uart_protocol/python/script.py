import serial
import time

# -------------------------
# Configuración UART
# -------------------------
ser = serial.Serial(
    port='COM4',              # cámbialo si estás en Linux
    baudrate=9600,
    bytesize=serial.EIGHTBITS,
    parity=serial.PARITY_NONE,
    stopbits=serial.STOPBITS_ONE,
    timeout=0.1
)

time.sleep(2)
print("UART lista (TX/RX + envío de instrucciones).\n")

# -------------------------
# Instrucciones 32 bits
# -------------------------
instructions = [
    "00000000"
    "00000000"
    "00000101"
    "00010011",
    "00000000"
    "00010000"
    "00000101"
    "10010011",
    "00000000"
    "10100000"
    "00000110"
    "00010011",
    "00000000"
    "00000110"
    "00001100"
    "01100011",
    "00000000"
    "10110101"
    "00000010"
    "10110011",
    "00000000"
    "10110000"
    "00000101"
    "00110011",
    "00000000"
    "01010000"
    "00000101"
    "10110011",
    "11111111"
    "11110110"
    "00000110"
    "00010011",
    "11111110"
    "11011111"
    "11110000"
    "01101111",
    "00000000"
    "00000000"
    "00000000"
    "01101111"
]

# -------------------------
# Parámetros de envío
# -------------------------
send_header_byte   = True     # si quieres enviar el '10' inicial
header_value       = 10      # valor del header (cambiar si se desea)
inter_byte_delay   = 0.002    # delay entre bytes (segundos)
reverse_endianness = True     # True si la placa espera LSB primero (little-endian)

# -------------------------
# Envío inicial (header bien formado)
# -------------------------

print("Enviando encabezado...")
if send_header_byte:
    ser.write(bytes([header_value]))   # un solo byte 0x0A
    ser.flush()
    print(f"-> Header enviado: 0x{header_value:02X}")

time.sleep(0.01)

# -------------------------
# Envío de instrucciones (4 bytes cada una)
# -------------------------

print("Enviando instrucciones...\n")
for inst in instructions:
    if len(inst) != 32:
        print(f"❌ Instrucción mal formada (no tiene 32 bits): {inst}")
        continue

    # convertir 4 grupos de 8 bits en bytes (b0 = bits 0..7)
    b0 = int(inst[0:8],   2)
    b1 = int(inst[8:16],  2)
    b2 = int(inst[16:24], 2)
    b3 = int(inst[24:32], 2)

    if reverse_endianness:
        bytes_to_send = [b3, b2, b1, b0]
    else:
        bytes_to_send = [b0, b1, b2, b3]

    # enviar cada byte con pequeño delay y debug
    for b in bytes_to_send:
        ser.write(bytes([b]))
        print(f"-> enviado byte: 0x{b:02X} (decimal {b})  repr={repr(bytes([b]))}")
        time.sleep(1)
    ser.flush()
    print(f"--> instrucción completa enviada: {inst}  bytes={[f'0x{b:02X}' for b in bytes_to_send]}\n")

print("✔ Todas las instrucciones enviadas.\n")

# -------------------------
# Modo interactivo TX/RX
# -------------------------
try:
    while True:
        # recepción no bloqueante
        if ser.in_waiting > 0:
            rx = ser.read(ser.in_waiting)  # lee todos los bytes disponibles
            print("<- Recibido raw:", rx, "hex:", [f"0x{b:02X}" for b in rx])

        data = input("Escribe un número (0-255) para enviar: ")

        try:
            value = int(data)
            if 0 <= value <= 255:
                ser.write(bytes([value]))
                ser.flush()
                print(f"-> Enviado (8 bits): {value} (0x{value:02X})")
            else:
                print("❌ Debe ser un valor entre 0 y 255.")
        except ValueError:
            print("❌ Entrada inválida.")

except KeyboardInterrupt:
    print("\nCerrando puerto...")

ser.close()