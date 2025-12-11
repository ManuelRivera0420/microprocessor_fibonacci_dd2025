import tkinter as tk
from tkinter import messagebox
import serial
import time


def fibonacci(n):
    n=n+2
    serie = [0, 1]
    for _ in range(2, n):
        serie.append(serie[-1] + serie[-2])

    hex_result = format(serie[-1], 'x')
    return serie[-1], hex_result


def enviar_uart(imm):
    port = 'COM4'
    baudrate = 9600
    timeout = 1

    # Calcular partes del inmediato
    imm_high = (imm & 0x0F) << 4
    imm_low  = (imm >> 4) & 0xFF

    payload = [
        bytes([0x13, 0x05, 0x00, 0x00]),
        bytes([0x93, 0x05, 0x10, 0x00]),
        bytes([0x13, 0x06, imm_high, imm_low]),
        bytes([0x63, 0x0C, 0x06, 0x00]),
        bytes([0xB3, 0x02, 0xB5, 0x00]),
        bytes([0x13, 0x85, 0x05, 0x00]),
        bytes([0x93, 0x85, 0x02, 0x00]),
        bytes([0x13, 0x06, 0xF6, 0xFF]),
        bytes([0x6F, 0xF0, 0xDF, 0xFE]),
        bytes([0x6F, 0x00, 0x00, 0x00])
    ]

    try:
        ser = serial.Serial(port, baudrate, timeout=timeout)
        time.sleep(0.05)

        # Enviar número de instrucciones
        ser.write(b'\x0A')
        time.sleep(0.01)

        for frame in payload:
            ser.write(frame)
            time.sleep(0.005)

        ser.close()

    except Exception as e:
        raise RuntimeError(f"UART ERROR: {e}")


def calcular_fib():
    """Callback del botón."""
    try:
        imm = int(entry.get())
        if imm <= 0:
            raise ValueError("El número debe ser positivo.")

        # Calcular Fibonacci
        fib_int, fib_hex = fibonacci(imm)

        # Enviar UART
        enviar_uart(imm)

        messagebox.showinfo(
            "Resultado",
            f"Fibonacci({imm}) = {fib_int}\nHex: {fib_hex}\n\nUART enviado correctamente."
        )

    except Exception as e:
        messagebox.showerror("Error", str(e))


# ============================================
#   VENTANA PRINCIPAL
# ============================================

root = tk.Tk()
root.title("Microprocesador Fibonacci")
root.geometry("350x200")

label = tk.Label(root, text="Iteración (n):", font=("Arial", 12))
label.pack(pady=10)

entry = tk.Entry(root, font=("Arial", 12), justify="center")
entry.pack(pady=5)

btn = tk.Button(root, text="Calcular y Enviar", font=("Arial", 12, "bold"),
                command=calcular_fib, bg="#4CAF50", fg="white")
btn.pack(pady=20)

root.mainloop()
