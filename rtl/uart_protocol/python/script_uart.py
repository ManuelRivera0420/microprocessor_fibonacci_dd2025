import serial
import time

# Configure the serial port parameters
# Replace 'COMx' with your actual serial port name (e.g., 'COM3' on Windows, '/dev/ttyUSB0' on Linux)
# Set the baud rate to match your device
port = 'COMx'
baudrate = 9600
timeout = 1  # Timeout in seconds for read/write operations

try:
    # Open the serial port
    ser = serial.Serial(port, baudrate, timeout=timeout)
    print(f"Serial port {port} opened successfully.")

    # Data to be sent (must be a bytes object)
    # You can encode a string to bytes using .encode()
    data_to_send = "Hello, UART!".encode('utf-8')
    # Or create bytes directly
    # data_to_send = b'\x01\x02\x03\x04'

    # Write the bytes to the serial port
    bytes_written = ser.write(data_to_send)
    print(f"Sent {bytes_written} bytes: {data_to_send}")

    # Optional: Wait for a response or ensure data is sent
    time.sleep(0.1)

    # Close the serial port
    ser.close()
    print(f"Serial port {port} closed.")

except serial.SerialException as e:
    print(f"Error opening or communicating with serial port: {e}")
except Exception as e:
    print(f"An unexpected error occurred: {e}")