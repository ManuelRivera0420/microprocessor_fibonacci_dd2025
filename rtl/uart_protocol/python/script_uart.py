import serial
import time

imm = int(input("Enter the # iteration for the fibonacci series: "))

def fibonacci(n):
    serie = [0, 1]
    for _ in range(2, n):
        serie.append(serie[-1] + serie[-2])

    hex_result = format(serie[n-1], 'x')
    print(f"El resultado de la serie Fibonacci para el número ingresado es: Hex: {hex_result}, int: {serie[-1]}")
    serie = [0, 1]
    return None

fibonacci(imm)

port = 'COM4'
baudrate = 9600
timeout = 1

# Rango del inmediato que quieres enviar
IMM_START = 0x0000
IMM_END   = 0x00FF    # cámbialo al rango que necesites

try:
    ser = serial.Serial(port, baudrate, timeout=timeout)
    time.sleep(0.05)

    # Separar el inmediato en dos bytes (little-endian)
    imm_high = (imm & 0x0F) << 4        # LSB
    imm_low  = (imm >> 4) & 0xFF # MSB

    # Construye payload dinámico
    payload = [
        bytes([0x13, 0x05, 0x00, 0x00]),
        bytes([0x93, 0x05, 0x10, 0x00]),
        bytes([0x13, 0x06, imm_high, imm_low]),  # ← SE ACTUALIZA AQUÍ
        bytes([0x63, 0x0C, 0x06, 0x00]),
        bytes([0xB3, 0x02, 0xB5, 0x00]),
        bytes([0x13, 0x85, 0x05, 0x00]),
        bytes([0x93, 0x85, 0x02, 0x00]),
        bytes([0x13, 0x06, 0xF6, 0xFF]),
        bytes([0x6F, 0xF0, 0xDF, 0xFE]),
        bytes([0x6F, 0x00, 0x00, 0x00])
    ]

    print(f"\n=== Enviando inmediato {hex(imm)} → HIGH={hex(imm_high)}, LOW={hex(imm_low)} ===")

    # Enviar número de instrucciones (10 → 0x0A)
    n_instr = b'\x0A'
    ser.write(n_instr)
    time.sleep(0.005)

    # Enviar instrucciones una por una
    for frame in payload:
        ser.write(frame)
        print(f"Sent: {frame}")
        time.sleep(0.005)

    # Pausa opcional entre iteraciones
    time.sleep(0.05)
    ser.close()
    print("Serial port closed.")

except Exception as e:
    print("ERROR:", e)
