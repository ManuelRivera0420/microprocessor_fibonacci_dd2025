import serial
import time

port = 'COM3'
baudrate = 9600
timeout = 0.1

try:
    ser = serial.Serial(port, baudrate, timeout=timeout)
    print(f"Opened {port}")

    time.sleep(0.05)

    payload = [
        b'\x93\x04\x00\x00',
        b'\x93\x05\x00\x10',
        b'\x93\x06\x00\x0A',
        b'\x63\x0C\x06\x00',
        b'\xB3\x0A\x00\x0B',
        b'\xB3\x05\x00\x0B',
        b'\xB3\x05\x00\x05',
        b'\x93\x06\x00\xF6',
        b'\x6F\x00\xFF\xDD',
        b'\x6F\x00\x00\x00'
    ]

    # Número de instrucciones
    ser.write(b'\x0A')
    print("TX: 0A")

    # Esperar eco de 0x0A (1 byte)
    time.sleep(0.002)
    echo = ser.read(ser.in_waiting or 1)
    print("RX:", echo)

    # Enviar y recibir uno por uno
    for frame in payload:
        ser.write(frame)
        print("TX:", frame)

        # Le das chance al FPGA de procesar y hacer eco
        time.sleep(0.002)

        # Leer exactamente 4 bytes (tu frame)
        echo = ser.read(4)
        print("RX:", echo)

        # Si no recibes 4 bytes, lo mostramos igual para debug
        if len(echo) != 4:
            print("⚠ Eco incompleto")

    ser.close()
    print("Closed.")

except Exception as e:
    print("ERROR:", e)
