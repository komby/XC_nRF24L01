/*
 * XC_nRF24L01.xc
 *
 *  Created on: Feb 27, 2014
 *      Author: Greg Scull
 *
 *
 */

#include <platform.h>
#include <xs1.h>
#include <print.h>
#include <stdio.h>
#include <string.h>
#include <spi_master.h>

#include "XC_nRF24L01.h"


/**
 * Setup the CSN pin
 */
void set_nrf_csn( xc_nRF24L01 &pRadio, spi_master_interface &pSpi, int pValue) {
    pRadio.nrf_csn <: pValue;
}

/**
 * Setup the CE pin
 */
void set_nrf_ce(xc_nRF24L01 &pRadio, spi_master_interface &pSpi, int pValue) {
    pRadio.nrf_ce <: pValue;
}

/**
 * Set the payload size for the radio, and payload specified.
 */
void nrfSetPayloadSize(xc_nRF24L01 &pRadio, spi_master_interface &pSpi,int pPayloadSize) {
    //TODO Missing Implementation
}

/**
 * Set The AutoACK (not used)
 */
void nrfSetAutoAck(xc_nRF24L01 &pRadio, spi_master_interface &pSpi,int pAutoAck) {
    //TODO Missing Implementation
}

/**
 * Read the payload size register settigns
 */
int nrfGetPayloadSize(xc_nRF24L01 &pRadio, spi_master_interface &pSpi) {
    //TODO Missing Implementation
    return 0;
}

/**
 * Read a single byte from the specified register
 */
int nrfReadRegister(xc_nRF24L01 &pRadio, spi_master_interface &pSpi,unsigned char pRegister) {
    set_nrf_csn(pRadio, pSpi, LOW);
    spi_master_out_byte(pSpi, R_REGISTER | (REGISTER_MASK & pRegister));
    unsigned char readByte = spi_master_in_byte(pSpi);
    set_nrf_csn(pRadio, pSpi, HIGH);
    return readByte;
}

/**
 *
 */
char nrfReadRegisterBuf(xc_nRF24L01 &pRadio, spi_master_interface &pSpi,char reg, char buf[], int len) {
    char status;

    set_nrf_csn(pRadio, pSpi, LOW);

    spi_master_out_byte(pSpi, (R_REGISTER | (REGISTER_MASK & reg)));

    // const int length = len;
    //     char buf[32];
    for (int i = 0; len--; i++)
        buf[i] = spi_master_in_byte(pSpi);

    set_nrf_csn(pRadio, pSpi, HIGH);

    return status;

}

/**
 *
 */
int nrfWriteRegisterTX(xc_nRF24L01 &pRadio, spi_master_interface &pSpi,int pReg) {

    int status;

      set_nrf_csn(pRadio, pSpi, LOW);
      spi_master_out_byte(pSpi, W_REGISTER | (REGISTER_MASK & pReg));
      int pLength=5;
      for (int i = 0; pLength--; i++)
          spi_master_out_byte(pSpi, pRadio.tx_pipe[i]);

      set_nrf_csn(pRadio, pSpi, HIGH);

      return status;
}

/**
 *
 */
int nrfWriteRegisterRX(xc_nRF24L01 &pRadio, spi_master_interface &pSpi,int pReg) {

    int status;

      set_nrf_csn(pRadio, pSpi, LOW);
      spi_master_out_byte(pSpi, W_REGISTER | (REGISTER_MASK & pReg));
      int pLength=5;
      for (int i = 0; pLength--; i++)
          spi_master_out_byte(pSpi, pRadio.rx_pipe[i]);

      set_nrf_csn(pRadio, pSpi, HIGH);

      return status;

}

/**
 *
 */
int nrfWriteRegisterWithBuffer(xc_nRF24L01 &pRadio, spi_master_interface &pSpi,int pReg,  char pBuffer[], int pLength) {
    int status;

    set_nrf_csn(pRadio, pSpi, LOW);
    spi_master_out_byte(pSpi, W_REGISTER | (REGISTER_MASK & pReg));

    for (int i = 0; pLength--; i++)
        spi_master_out_byte(pSpi, pBuffer[i]);

    set_nrf_csn(pRadio, pSpi, HIGH);

    return status;
}

/**
 *
 */
int nrfWriteRegister(xc_nRF24L01 &pRadio, spi_master_interface &pSpi,int pReg, unsigned char pValue) {
    int status;

    printf("write_register(%#010x,%#010x)\r\n", pReg, pValue);

    set_nrf_csn(pRadio, pSpi, LOW);
    //void spi_master_out_byte(spi_master_interface &spi_if, unsigned char data);
    spi_master_out_byte(pSpi, W_REGISTER | (REGISTER_MASK & pReg));
    spi_master_out_byte(pSpi, pValue);
    set_nrf_csn(pRadio, pSpi, HIGH);

    return status;
}

/**
 *
 */
void nrfSetChannel(xc_nRF24L01 &pRadio, spi_master_interface &pSpi) {
    const char max_channel = 127;
    //nrfWriteRegister(pRadio, pSpi, RF_CH);
    int status;

       printf("setChannel(%#010x,%#010x)\r\n", RF_CH, pRadio.rf_channel);

       set_nrf_csn(pRadio, pSpi, LOW);
       //void spi_master_out_byte(spi_master_interface &spi_if, unsigned char data);
       spi_master_out_byte(pSpi, W_REGISTER | (REGISTER_MASK & RF_CH));
       spi_master_out_byte(pSpi, pRadio.rf_channel);
       set_nrf_csn(pRadio, pSpi, HIGH);

}

/**
 *
 */
void nrfOpenWritingPipe(xc_nRF24L01 &pRadio, spi_master_interface &pSpi) {
    nrfWriteRegisterRX(pRadio, pSpi, RX_ADDR_P0);
    nrfWriteRegisterTX(pRadio, pSpi, TX_ADDR);

    // const char max_payload_size = 32;
    nrfWriteRegister(pRadio, pSpi, RX_PW_P0, 32);

}

/**
 *
 */
void nrfOpenReadingPipe(xc_nRF24L01 &pRadio, spi_master_interface &pSpi,char child) {
    char child_pipe[] = { RX_ADDR_P0, RX_ADDR_P1, RX_ADDR_P2, RX_ADDR_P3,
            RX_ADDR_P4, RX_ADDR_P5 };
    char child_payload_size[] = { RX_PW_P0, RX_PW_P1, RX_PW_P2, RX_PW_P3,
            RX_PW_P4, RX_PW_P5 };
    char
            child_pipe_enable[] = { ERX_P0, ERX_P1, ERX_P2, ERX_P3, ERX_P4,
                    ERX_P5 };
    //TODO Fix Implementation of pipe reading address when tx/rx switching
    // If this is pipe 0, cache the address.  This is needed because
    // openWritingPipe() will overwrite the pipe 0 address, so
    // startListening() will have to restore it.
    //    char pipe0_reading_address [6];
    //      if (child == 0)
    //        pipe0_reading_address = pAddress;

    if (child <= 6) {
        // For pipes 2-5, only write the LSB
        if (child < 2)
            nrfWriteRegisterRX(pRadio, pSpi, child_pipe[child]);
        else
            nrfWriteRegisterRX(pRadio, pSpi, child_pipe[child]);

        nrfWriteRegister(pRadio, pSpi, child_payload_size[child], 32);

        // Note it would be more efficient to set all of the bits for all open
        // pipes at once.  However, I thought it would make the calling code
        // more simple to do it this way.
        nrfWriteRegister(pRadio, pSpi, EN_RXADDR,
                (nrfReadRegister(pRadio, pSpi, EN_RXADDR) | _BV(child_pipe_enable[child])));
    }
}

/**
 *
 */
int nrfWritePayload(xc_nRF24L01 &pRadio, spi_master_interface &pSpi,const char pBuffer[], int pLength) {
    int status;

    int data_len = pLength;
    //commented out stuff for dynamic payload size since it will not be used.
    // const uint8_t* current = reinterpret_cast<const uint8_t*>(buf);
    //int blank_len = dynamic_payloads_enabled ? 0 : payload_size - data_len;
    //printf("[Writing %u bytes %u blanks]",data_len,blank_len);

    set_nrf_csn(pRadio, pSpi, LOW);
    spi_master_out_byte(pSpi, W_TX_PAYLOAD);
    //send one byte at a time,  it didnt work with a buffered approach.
    for (int i = 0; data_len--; i++)
        spi_master_out_byte(pSpi, pBuffer[i]);

    set_nrf_csn(pRadio, pSpi, HIGH);
    return status;
}

/**
 *
 */
int nrfReadPayload(xc_nRF24L01 &pRadio, spi_master_interface &pSpi,int pBuffer[], int pLength) {
    //TODO IMPLEMENT NRFReadPayload
}

/**
 *
 */
void nrfFlushRXBuffer(xc_nRF24L01 &pRadio, spi_master_interface &pSpi) {
    set_nrf_csn(pRadio, pSpi, LOW);
    spi_master_out_byte(pSpi, FLUSH_RX);
    set_nrf_csn(pRadio, pSpi, HIGH);
}

/**
 *
 */
void nrfFlushTXBuffer(xc_nRF24L01 &pRadio, spi_master_interface &pSpi) {
    set_nrf_csn(pRadio, pSpi, LOW);
    spi_master_out_byte(pSpi, FLUSH_TX);
    set_nrf_csn(pRadio, pSpi, HIGH);
}

/**
 *
 */
int nrfGetStatus(xc_nRF24L01 &pRadio, spi_master_interface &pSpi) {
    char status;

    set_nrf_csn(pRadio, pSpi, LOW);
    status = spi_master_in_byte(pSpi);
    set_nrf_csn(pRadio, pSpi, HIGH);

    return status;
}

/**
 *
 */
void nrfPrintStatus(int pStatus) {
    printf(
            "STATUS\t\t = 0x%02x RX_DR=%x TX_DS=%x MAX_RT=%x RX_P_NO=%x TX_FULL=%x\r\n",
            pStatus, (pStatus & _BV(RX_DR)) ? 1 : 0,
            (pStatus & _BV(TX_DS)) ? 1 : 0, (pStatus & _BV(MAX_RT)) ? 1 : 0,
            ((pStatus >> RX_P_NO) & 0b111), (pStatus & _BV(TX_FULL)) ? 1 : 0);
}

/**
 *
 */
void nrfPrintByteRegisters(xc_nRF24L01 &pRadio, spi_master_interface &pSpi,const char name[], char reg, int qty) {
    char extra_tab = strlen(name) < 8 ? '\t' : 0;
    printf("\t%s%c =", name, extra_tab);
    //printf("TODO nrfPrintByteRegister - pointer arithmetic\n");
    while (qty--)
        printf(" 0x%02x", nrfReadRegister(pRadio, pSpi, reg++));
    printf("\r\n");
}

/**
 *
 */
void nrfPrintByteRegister(xc_nRF24L01 &pRadio, spi_master_interface &pSpi,const char name[], char reg) {
    nrfPrintByteRegisters(pRadio, pSpi, name, reg, 1);
}

/**
 *
 */
void nrfSetPALevel(xc_nRF24L01 &pRadio, spi_master_interface &pSpi,rf24_datarate_e pPaLevel) {
    char setup = nrfReadRegister(pRadio, pSpi, RF_SETUP);
    setup &= ~(_BV(RF_PWR_LOW) | _BV(RF_PWR_HIGH));

    // switch uses RAM (evil!)
    if (pPaLevel == RF24_PA_MAX) {
        setup |= (_BV(RF_PWR_LOW) | _BV(RF_PWR_HIGH));
    } else if (pPaLevel == RF24_PA_HIGH) {
        setup |= _BV(RF_PWR_HIGH);
    }
    else if ( pPaLevel == RF24_PA_LOW )
    {
        setup |= _BV(RF_PWR_LOW);
    }
    else if ( pPaLevel == RF24_PA_MIN )
    {
        // nothing
    }
    else if ( pPaLevel == RF24_PA_ERROR )
    {
        // On error, go to maximum PA
        setup |= (_BV(RF_PWR_LOW) | _BV(RF_PWR_HIGH));
    }

    nrfWriteRegister( pRadio, pSpi, RF_SETUP, setup );
}

/**
 *
 */
void nrfSetCRCLength(xc_nRF24L01 &pRadio, spi_master_interface &pSpi,int pCRCLength) {
    char config = nrfReadRegister(pRadio, pSpi, NRF_CONFIG & ~(_BV(CRCO) | _BV(EN_CRC)));

    // switch uses RAM (evil!)
    if (pCRCLength == RF24_CRC_DISABLED) {
        // Do nothing, we turned it off above.
    } else if (pCRCLength == RF24_CRC_8) {
        config |= _BV(EN_CRC);
    }
    else
    {
        config |= _BV(EN_CRC);
        config |= _BV( CRCO );
    }
    nrfWriteRegister(pRadio, pSpi,  NRF_CONFIG, config );
}

/**
 *
 */
void nrfPrintAddressRegisters(xc_nRF24L01 &pRadio, spi_master_interface &pSpi,char name[], char reg, char qty) {
    char extra_tab = strlen(name) < 8 ? '\t' : 0;
    printf("\t%s%c =", name, extra_tab);

    while (qty--) {
        char buffer[5];
        nrfReadRegisterBuf(pRadio, pSpi, reg++, buffer, sizeof buffer);

        printf(" 0x");
        //char  bufptr[]  = buffer + sizeof buffer;
        int size = sizeof buffer;
        while (--size >= 0)
            printf("%02x", buffer[size]);
    }

    printf("\r\n");
}

/**
 *
 */
void nrfPowerUp(xc_nRF24L01 &pRadio, spi_master_interface &pSpi) {
    nrfWriteRegister(pRadio, pSpi, NRF_CONFIG, nrfReadRegister(pRadio, pSpi, NRF_CONFIG) | _BV(PWR_UP));
}

/**
 *
 */
rf24_datarate_e nrfGetDataRate(xc_nRF24L01 &pRadio, spi_master_interface &pSpi) {
    rf24_datarate_e result;
    char dr = nrfReadRegister(pRadio, pSpi, RF_SETUP & (_BV(RF_DR_LOW) | _BV(RF_DR_HIGH)));

    // switch uses RAM (evil!)
    // Order matters in our case below
    if (dr == _BV(RF_DR_LOW)) {
        // '10' = 250KBPS
        result = RF24_250KBPS;
    } else if (dr == _BV(RF_DR_HIGH)) {
        // '01' = 2MBPS
        result = RF24_2MBPS;
    } else {
        // '00' = 1MBPS
        result = RF24_1MBPS;
    }
    return result;
}

/**
 *
 */
rf24_pa_dbm_e nrfGetPALevel(xc_nRF24L01 &pRadio, spi_master_interface &pSpi) {
    rf24_pa_dbm_e result = RF24_PA_ERROR;
    char power = nrfReadRegister(pRadio, pSpi, RF_SETUP) & (_BV(RF_PWR_LOW)
            | _BV(RF_PWR_HIGH));

    // switch uses RAM (evil!)
    if (power == (_BV(RF_PWR_LOW) | _BV(RF_PWR_HIGH))) {
        result = RF24_PA_MAX;
    } else if (power == _BV(RF_PWR_HIGH)) {
        result = RF24_PA_HIGH;
    } else if (power == _BV(RF_PWR_LOW)) {
        result = RF24_PA_LOW;
    } else {
        result = RF24_PA_MIN;
    }

    return result;
}

/**
 *
 */
rf24_crclength_e nrfGetCRCLength(xc_nRF24L01 &pRadio, spi_master_interface &pSpi) {
    rf24_crclength_e result = RF24_CRC_DISABLED;
    char config = nrfReadRegister(pRadio, pSpi, NRF_CONFIG) & (_BV(CRCO) | _BV(EN_CRC));

    if (config & _BV(EN_CRC )) {
        if (config & _BV(CRCO))
            result = RF24_CRC_16;
        else
            result = RF24_CRC_8;
    }

    return result;
}

/**
 *
 */
void nrfPrintDetails(xc_nRF24L01 &pRadio, spi_master_interface &pSpi) {
    nrfPrintStatus(nrfGetStatus(pRadio, pSpi));

    nrfPrintAddressRegisters(pRadio, pSpi,"RX_ADDR_P0-1", RX_ADDR_P0, 2);
    nrfPrintByteRegisters(pRadio, pSpi, "RX_ADDR_P2-5", RX_ADDR_P2, 4);
    nrfPrintAddressRegisters(pRadio, pSpi, "TX_ADDR", TX_ADDR, 1);

    nrfPrintByteRegisters(pRadio, pSpi, "RX_PW_P0-6", RX_PW_P0, 6);
    nrfPrintByteRegister(pRadio, pSpi, "EN_AA", EN_AA);
    nrfPrintByteRegister(pRadio, pSpi, "EN_RXADDR", EN_RXADDR);
    nrfPrintByteRegister(pRadio, pSpi, "RF_CH", RF_CH);
    nrfPrintByteRegister(pRadio, pSpi, "RF_SETUP", RF_SETUP);
    nrfPrintByteRegister(pRadio, pSpi, "NRF_CONFIG", NRF_CONFIG);
    nrfPrintByteRegisters(pRadio, pSpi, "DYNPD/FEATURE", DYNPD, 2);

    int dr = nrfGetDataRate(pRadio, pSpi);
    printf("Data Rate\t =");
    switch (dr) {
        case    0:
                printf("1MBPS\n");
                break;
        case 1:
            printf("2MBPS\r\n");
            break;
        case 2:
            printf("250kbps\r\n");
    }


    //TODO Reimplement the pvariant check print statement
    //printf("Model\t\t = %S\r\n",pgm_read_word(&rf24_model_e_str_P[NRFisPVariant()]));
    int crcl = nrfGetCRCLength(pRadio, pSpi);
    printf("CRC Length\t = %S\r\n", crcl);
    int pap = nrfGetPALevel(pRadio, pSpi);

    printf("PA Power\t = ");
    switch(pap) {
        case 0:
            printf("PA_MIN\r\n");
            break;
        case 1:
            printf("PA_LOW\r\n");
            break;
        case 2:
            printf("LA_MED\r\n");
            break;
        case 3:
            printf("PA_HIGH\r\n");
            break;
        }
}

/**
 *
 */
void nrfSetDataRate(xc_nRF24L01 &pRadio, spi_master_interface &pSpi) {
    char result = 0;
    char setup = nrfReadRegister(pRadio, pSpi, RF_SETUP);

    // HIGH and LOW '00' is 1Mbs - our default
    pRadio.wideBand = 0 ;
    setup &= ~(_BV(RF_DR_LOW) | _BV(RF_DR_HIGH));
    if (pRadio.rf_dataRate == RF24_250KBPS) {
        // Must set the RF_DR_LOW to 1; RF_DR_HIGH (used to be RF_DR) is already 0
        // Making it '10'.
        pRadio.wideBand = 0 ;
        setup |= _BV( RF_DR_LOW );

    }
            //TODO readd functionality for 2mbps support - not in intial due to usage needs
        //     else
        //     {
        ////       // Set 2Mbs, RF_DR (RF_DR_HIGH) is set 1
        ////       // Making it '01'
        ////       if ( speed == RF24_2MBPS )
        ////       {
        ////       //  wide_band = true ;
        ////         setup |= _BV(RF_DR_HIGH);
        ////       }
        ////       else
        ////       {
        ////         // 1Mbs
        ////        // wide_band = false ;
        ////       }
        //     }
    nrfWriteRegister(pRadio, pSpi, RF_SETUP, setup);

    // Verify our result
    if ( nrfReadRegister(pRadio, pSpi, RF_SETUP) == setup )
    {
        result = 1;
    }
    else
    {
        //wide_band = false;
    }

    return result;
}

/**
 *
 */
void nrfStartListening(xc_nRF24L01 &pRadio, spi_master_interface &pSpi) {
    nrfWriteRegister(pRadio, pSpi, NRF_CONFIG,
            nrfReadRegister(pRadio, pSpi, NRF_CONFIG) | _BV(PWR_UP) | _BV(PRIM_RX));
    nrfWriteRegister(pRadio, pSpi, NRF_STATUS, _BV(RX_DR) | _BV(TX_DS) | _BV(MAX_RT));

    // Restore the pipe0 adddress, if exists
    nrfWriteRegisterRX(pRadio, pSpi, RX_ADDR_P0);
    // nrfWriteRegister(RX_ADDR_P0, pipe0_reading_address), 5);

    // Flush buffers
    nrfFlushRXBuffer(pRadio, pSpi );
    nrfFlushTXBuffer(pRadio, pSpi );

    // Go!
    set_nrf_ce(pRadio, pSpi, HIGH);

    // wait for the radio to come up (130us actually only needed)

    //delayMicroseconds(130);
    timer t;
    unsigned time;
    t :> time;
    time += 15000;
    t when timerafter(time) :> void;
}

/**
 *
 */
void nrfStopListening(xc_nRF24L01 &pRadio, spi_master_interface &pSpi) {
    //TODO IMPORTANT Implement Stop Listening
}

/**
 *
 */
void nrfWrite(xc_nRF24L01 &pRadio, spi_master_interface &pSpi,const int pBuffer[], int pLength) {
    //TODO Implement nrfWrite?
}

/**
 *
 */
int nrfAvaliable(xc_nRF24L01 &pRadio, spi_master_interface &pSpi) {
    //TODO Implement the nrfAvalialbe function
}

/**
 *
 */
int nrfRead(xc_nRF24L01 &pRadio, spi_master_interface &pSpi, int pBuffer[], int pLength) {
    //TODO Implement nrfRead
}

/**
 *
 */
void nrfPowerDown(xc_nRF24L01 &pRadio, spi_master_interface &pSpi) {
    //TODO Implement Power Down
}


/**
 *
 */
void nrfDelayMicroseconds(int pMs){
    timer t;
            unsigned time;
            t :> time;
            time += (pMs*100);
            t when timerafter(time) :> void;
}

/**
 *
 */
void nrfBegin(xc_nRF24L01 &pRadio, spi_master_interface &pSpi) {
    //set ce low
    set_nrf_ce(pRadio, pSpi, LOW);
    //set csn high
    set_nrf_csn(pRadio, pSpi, HIGH);

    // Must allow the radio time to settle else configuration bits will not necessarily stick.
    // This is actually only required following power up but some settling time also appears to
    // be required after resets too. For full coverage, we'll always assume the worst.
    // Enabling 16b CRC is by far the most obvious case if the wrong timing is used - or skipped.
    // Technically we require 4.5ms + 14us as a worst case. We'll just call it 5ms for good measure.
    // WARNING: Delay is based on P-variant whereby non-P *may* require different timing.
    //delay 5 ms
    timer t;
    unsigned time;
    t :> time;
    time += 450000;
    t when timerafter(time) :> void;
    printf("setting register %#010x, with value: %#010x\n", SETUP_RETR,
            (0b0100 << ARD) | (0b1111 << ARC));
    nrfWriteRegister(pRadio, pSpi, SETUP_RETR, (0b0100 << ARD) | (0b1111 << ARC));

    nrfSetPALevel(pRadio, pSpi, RF24_PA_MAX);

    nrfSetDataRate(pRadio, pSpi);

    // Initialize CRC and request 2-byte (16bit) CRC
    nrfSetCRCLength(pRadio, pSpi, RF24_CRC_16);

    // Disable dynamic payloads, to match dynamic_payloads_enabled setting
    nrfWriteRegister(pRadio, pSpi, DYNPD, 0);

    // Reset current status
    // Notice reset and flush is the last thing we do
    nrfWriteRegister(pRadio, pSpi, NRF_STATUS, _BV(RX_DR) | _BV(TX_DS) | _BV(MAX_RT));

    nrfSetChannel(pRadio, pSpi);

    //set the retries to 0
    nrfWriteRegister(pRadio, pSpi, SETUP_RETR, (0 & 0xf) << ARD | (0 & 0xf) << ARC);

    //shut off auto ack
    nrfWriteRegister(pRadio, pSpi, EN_AA, 0);

    nrfOpenWritingPipe(pRadio, pSpi);
    nrfOpenReadingPipe(pRadio, pSpi, 1);

    nrfWriteRegister(pRadio, pSpi,
            NRF_CONFIG,
            (nrfReadRegister(pRadio, pSpi,NRF_CONFIG) | _BV(PWR_UP)) & ~_BV(PRIM_RX)); //set up radio for writing!
    nrfFlushTXBuffer(pRadio, pSpi); //Clear the TX FIFO Buffers
    //powerup
    nrfPowerUp(pRadio, pSpi);
    set_nrf_ce(pRadio, pSpi, HIGH);
}
