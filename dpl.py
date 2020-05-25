# Python server for listening to OpenTTD debugging output over a network connection
# dpl.py - Debugging port listener
################################################################################
# Imports
################################################################################

import json
import logging
import os
import pdb
import requests
import signal
import socket
import struct
import threading
import time
import sys
import uuid

from datetime import datetime

################################################################################
# Setup logging configuration
################################################################################

logging_format = '%(asctime)-15s %(message)s'
logging.basicConfig(filename='debug-port-svr.log', level=logging.DEBUG, format=logging_format) # Log to file
console_logger = logging.StreamHandler() # Log to console as well
console_logger.setFormatter(logging.Formatter(logging_format))
logging.getLogger().addHandler(console_logger)

# Suppress messages emitted by urllib3.connectionpool; its too verbose
# logging.getLogger("urllib3.connectionpool").setLevel(logging.WARNING)
# logging.getLogger("requests").setLevel(logging.WARNING)

################################################################################
# Setup signal handler
################################################################################

def default_signal_handler(signalnum, frame):
    """ default handler for all signals
    """
    if signalnum == signal.SIGINT:
        logging.debug('Signal SIGINT received')
        # TODO: Not sure if we need some form of graceful termination here
        #       Do a sys.exit() for now
        sys.exit()
    if signalnum == signal.SIGTERM:
        logging.debug('Signal SIGTERM received')


################################################################################
# Main script
################################################################################

if __name__ == '__main__':
    logging.critical("%8s test message %s" % ("CRITICAL", str(datetime.utcnow())))
    logging.error("%8s test message %s" % ("ERROR", str(datetime.utcnow())))
    logging.warning("%8s test message %s" % ("WARNING", str(datetime.utcnow())))
    logging.info("%8s test message %s" % ("INFO", str(datetime.utcnow())))
    logging.debug("%8s test message %s" % ("DEBUG", str(datetime.utcnow())))

    # Map signals to their respective handlers
    signal.signal(signal.SIGINT, default_signal_handler)
    signal.signal(signal.SIGTERM, default_signal_handler)

    host_ip = "127.0.0.1"
    host_port = 3981
    BUFFER_SIZE = 1024 * 64
    receive_buffer = bytearray(BUFFER_SIZE)

    # Outer while-loop
    # Ensures that we start an instance of the server when it "crashes"
    # "Crashes" may occurred when OpenTTD closes
    # ZX:   Think there's a logic flaw somewhere in the way I wrote the below.
    #       But its working for now, so ignoring it...
    while 1:
        
        try:
            logging.debug("Run debug port server: IP: [{0}] Port:[{1}]".format(host_ip, host_port))
            server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            server_socket.setsockopt(socket.IPPROTO_TCP, socket.TCP_NODELAY, 1)
            server_socket.bind((host_ip, host_port))
            server_socket.listen(1)

            # TODO: Spin up a thread for every client that connected to us
            # For now, just use a loop
            while 1:
                logging.debug("Waiting for client")
                client_socket, client_address = server_socket.accept()
                logging.debug("Connected from {0}".format(client_address))
                while 1: # Handle reads here
                    bytes_received = client_socket.recv_into(receive_buffer, BUFFER_SIZE)
                    if bytes_received == 0:
                        logging.debug("Remote connection close")
                        client_socket.shutdown(socket.SHUT_RDWR)
                        client_socket.close()
                        break
                    if bytes_received == 0:
                        break
                    logging.debug("%s", receive_buffer[:bytes_received].decode("utf-8"))
                    
        except Exception as ex:
            logging.error(ex)
