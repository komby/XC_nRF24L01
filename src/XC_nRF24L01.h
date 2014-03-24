/*
 * XC_nRF24L01.h
 *  XC Driver for nRF24L01 2.4 GHz wireless transcievers
 *  XC Porting and adaptation for multi core usage.
 *
 *  For More information about nRF24L01+ wireless transceivers visit
 *  http://www.komby.com
 *
 *  Created on: Feb 27, 2014
 *      Author: Greg Scull <komby@komby.com>
 *
 *
 *  This project is an XC port of the RF24 library for Arduino written by
 *  J. Coliz <maniacbug@ymail.com>
 *  For more information about that project visit:
 *  http://github.com/maniacbug/RF24/
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * version 2 as published by the Free Software Foundation.
 *
 */

#ifndef XC_NRF24L01_H_
#define XC_NRF24L01_H_

#include <spi_master.h>
#include "nRF24L01.h"

//Define some things to make compatibility with the Arduino library easier
#define LOW 0
#define HIGH 1
//macro left from the RF24 Library
#define _BV( bit ) ( 1<<(bit) )


//xc_nRF24L01 struct to hold all properties and configuration needed by the transcievers
typedef struct xc_nRF24L01
{
    out port nrf_ce;
    out port nrf_csn;
    char rf_channel; //1-124
    rf24_datarate_e rf_dataRate;
    char tx_pipe[5];
    char rx_pipe[5];
    char wideBand;
    char pipe0_reading_address[5];
}   xc_nRF24L01;

/**
 *
 */
void set_nrf_csn(xc_nRF24L01 &pRadio, spi_master_interface &pSpi, int pValue);

/**
 *
 */
void set_nrf_ce(xc_nRF24L01 &pRadio, spi_master_interface &pSpi, int pValue);

/**
 *
 */
void nrfSetPayloadSize(xc_nRF24L01 &pRadio, spi_master_interface &pSpi,  int pPayloadSize);

/**
 *
 */
void nrfSetAutoAck(xc_nRF24L01 &pRadio, spi_master_interface &pSpi, int pAutoAck);

/**
 *
 */
int nrfGetPayloadSize(xc_nRF24L01 &pRadio, spi_master_interface &pSpi);

/**
 *
 */
int nrfReadRegister(xc_nRF24L01 &pRadio, spi_master_interface &pSpi, unsigned char pRegister);

/**
 *
 */
char nrfReadRegisterBuf(xc_nRF24L01 &pRadio, spi_master_interface &pSpi, char reg, char buf[], int len);

/**
 *
 */
int nrfWriteRegisterWithBuffer(xc_nRF24L01 &pRadio, spi_master_interface &pSpi, int pReg,  char pBuffer[], int pLength);

/**
 *
 */
int nrfWriteRegisterTX(xc_nRF24L01 &pRadio, spi_master_interface &pSpi,int pReg);

/**
 *
 */
int nrfWriteRegisterRX(xc_nRF24L01 &pRadio, spi_master_interface &pSpi,int pReg);

/**
 *
 */
int nrfWriteRegister(xc_nRF24L01 &pRadio, spi_master_interface &pSpi, int pReg, unsigned char pValue);

/**
 *
 */
void nrfSetChannel(xc_nRF24L01 &pRadio, spi_master_interface &pSpi);

/**
 *
 */
void nrfOpenReadingPipe(xc_nRF24L01 &pRadio, spi_master_interface &pSpi, char child);

/**
 *
 */
void nrfOpenWritingPipe(xc_nRF24L01 &pRadio, spi_master_interface &pSpi);


/**
 *
 */
int nrfWritePayload(xc_nRF24L01 &pRadio, spi_master_interface &pSpi, const char pBuffer[], int pLength);

/**
 *
 */
int nrfReadPayload(xc_nRF24L01 &pRadio, spi_master_interface &pSpi, int pBuffer[], int pLength);

/**
 *
 */
void nrfFlushRXBuffer(xc_nRF24L01 &pRadio, spi_master_interface &pSpi);

/**
 *
 */
void nrfFlushTXBuffer(xc_nRF24L01 &pRadio, spi_master_interface &pSpi);

/**
 *
 */
int nrfGetStatus(xc_nRF24L01 &pRadio, spi_master_interface &pSpi);

/**
 *
 */
void nrfPrintStatus( int pStatus);

/**
 *
 */
void nrfPrintByteRegisters(xc_nRF24L01 &pRadio, spi_master_interface &pSpi, const char name[], char reg, int qty);

/**
 *
 */
void nrfPrintByteRegister(xc_nRF24L01 &pRadio, spi_master_interface &pSpi, const char name[], char reg);

/**
 *
 */
void nrfSetPALevel(xc_nRF24L01 &pRadio, spi_master_interface &pSpi, rf24_datarate_e pPaLevel);

/**
 *
 */
void nrfSetCRCLength(xc_nRF24L01 &pRadio, spi_master_interface &pSpi, int pCRCLength);

/**
 *
 */
void nrfPrintAddressRegisters(xc_nRF24L01 &pRadio, spi_master_interface &pSpi, char name[], char reg, char qty);

/**
 *
 */
void nrfPowerUp(xc_nRF24L01 &pRadio, spi_master_interface &pSpi);

/**
 *
 */
rf24_datarate_e nrfGetDataRate(xc_nRF24L01 &pRadio, spi_master_interface &pSpi);

/**
 *
 */
rf24_pa_dbm_e nrfGetPALevel(xc_nRF24L01 &pRadio, spi_master_interface &pSpi);

/**
 *
 */
rf24_crclength_e nrfGetCRCLength(xc_nRF24L01 &pRadio, spi_master_interface &pSpi);

/**
 *
 */
void nrfPrintDetails(xc_nRF24L01 &pRadio, spi_master_interface &pSpi );

/**
 *
 */
void nrfSetDataRate(xc_nRF24L01 &pRadio, spi_master_interface &pSpi);

/**
 *
 */
void nrfStartListening(xc_nRF24L01 &pRadio, spi_master_interface &pSpi );

/**
 *
 */
void nrfStopListening(xc_nRF24L01 &pRadio, spi_master_interface &pSpi);

/**
 *
 */
int nrfAvaliable(xc_nRF24L01 &pRadio, spi_master_interface &pSpi);

/**
 *
 */
int nrfRead(xc_nRF24L01 &pRadio, spi_master_interface &pSpi, int pBuffer[], int pLength);

/**
 *
 */
void nrfPowerDown(xc_nRF24L01 &pRadio, spi_master_interface &pSpi );

/**
 *
 */
void nrfDelayMicroseconds(int pMs);

/**
 *
 */
void nrfBegin(xc_nRF24L01 &pRadio,spi_master_interface &pSpi);

#endif /* XC_NRF24L01_H_ */
