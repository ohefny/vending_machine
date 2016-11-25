/*
* Door Lock.c
*
* Created: 11/19/2016 3:53:37 PM
* Author: Be The Change
*/

#include <io.h>
#include <mega16.h>
#include <delay.h>
#include <alcd.h>
#include <string.h>
#include <stdlib.h>
#define InputCol PINA>>4
#define Keypad   PORTA
#define Keypad_dir DDRA
#define Coin_Input PINB.0
#define Green_Led  PORTB.4
unsigned char  password[]={'1','2','3','\0'};
unsigned char inputChar,price,enableAdminButton;
void eeprom_write(unsigned int uiAddress,unsigned char ucData)
{
    while( EECR & 0b00000010); //wait until EEPE==0

    EEAR=uiAddress;
    EEDR=ucData;
    EECR |=0b00000100; //write EEMPE=1
    EECR |=0b00000010; //write EEWE=1
}
unsigned char eeprom_read(unsigned int uiAddress)
{
    while(EECR & 0b00000010); //wait until EEWE==0

    EEAR=uiAddress;
    EECR|=0b00000001; //write EERE=1
    return EEDR;
}
void wait(){
    while((PINA>>4) > 0);
}
void resetScreen(){
    lcd_clear();
    lcd_gotoxy(0,0);
    lcd_puts("Choose Item::");
    lcd_gotoxy(0,15);
    price=0;
    inputChar=0;
} 
unsigned char getKey(){
    unsigned char i;


    for(i=1;i<=8;i=i<<1){
        PORTA = i;
        delay_ms(1);

        if(Keypad == 1){
            switch(InputCol){
            case 1: return '1';
            case 2: return '2';
            case 4: return '3';
            }
        }

        else if(Keypad == 2){
            switch(InputCol){
            case 1: return '4';
            case 2: return '5';
            case 4: return '6';
            }
        }

        else if(Keypad == 4){
            switch(InputCol){
            case 1: return '7';
            case 2: return '8';
            case 4: return '9';
            }
        }

        else {
            switch(InputCol){
            case 1: return '*';
            case 2: return '0';
            case 4: return '#';
            }
        }
    }

}
int waitForConfirm(){
    unsigned char key=0;
    wait();
    while (1)
    {       
        key=getKey();
        //wait();
        if (key != 0){
            if(key!='*'){

                return 0;
            }
            lcd_putchar(key);
            return 1;
        }


    }
}
void showPrice(void){
    //price=inputChar-'0';
    price=eeprom_read(inputChar-'0')-'0';
    lcd_clear();
    lcd_gotoxy(0,0);
    lcd_puts("price :");
    lcd_gotoxy(0,8);

    lcd_putchar(price+'0');
    delay_ms(100);
    lcd_clear();
    lcd_gotoxy(0,0);
    lcd_puts("Enter Coins ::");
    lcd_gotoxy(0,1);
    lcd_putchar('0');
    delay_ms(100) ;
}
void pickUpItem(){
    lcd_clear();
    lcd_gotoxy(0,0);
    Green_Led=1;
    lcd_puts("Pick up your Item");
    delay_ms(300);
    Green_Led=0;
   // PORTD.4=0;

}
void waitForCoins(){
    unsigned char count=0;
    while(Coin_Input);
    while(1){
        if(Coin_Input){
            count++;
            lcd_gotoxy(0,1);
            lcd_putchar(count+'0');
            while(Coin_Input&&count!=price);

        }
        if(price==count){
            pickUpItem();  
            resetScreen();
            return;
        }   
    }

}
void mainScreen(){
    resetScreen();
    while (1){
        lcd_gotoxy(0,15);         
        inputChar = getKey();
        if (inputChar != 0){
            if(inputChar<='0'||inputChar>'9'){
                resetScreen();
                continue;
            }

            lcd_putchar(inputChar);

            if(waitForConfirm()){
                showPrice();
                waitForCoins();       
            }
            else{
                resetScreen();
            }

            wait();   
        }
    }

}
void showMsg(char* msg,char*reset,int x,int y,int waiting){
    lcd_clear();
    lcd_gotoxy(0,0);
    lcd_puts(msg);
    delay_ms(waiting);
    lcd_clear();
    lcd_gotoxy(0,0);
    lcd_puts(reset);
    lcd_gotoxy(x,y);

}
void editPrice(unsigned char key){

    unsigned char price=0;
    wait();
    lcd_clear();
    lcd_gotoxy(0,0);
    lcd_puts("New Price:: ");
    lcd_gotoxy(14,0);
    while(1){
        price = getKey();
        if(price!=0){
            if(price=='#'){
                lcd_putchar('#');
                return ;
            }
            if(price<='0'||price>'9'){
                showMsg("Wrong Symbol..","New Price:: ",14,0,50);
                continue;
            }
            lcd_putchar(price);
            if(waitForConfirm()){
                eeprom_write(key-'0',price);
                showMsg("Price Updated...","Price Updated...",0,0,20);
                return;

            }
            else{
                showMsg("Wrong Symbol..","New Price:: ",14,0,50);
                continue;
            }
        }
        wait();

    }


}
void editItems(){
    unsigned char key=0;
    lcd_clear();
    lcd_gotoxy(0,0);
    lcd_puts("Enter Item:: ");

    while(1){
        key = getKey();
        if(key!=0){
            if(key=='#'){
                lcd_putchar('#');
                return ;
            }
            if(key<'0'||key>'9'){
                lcd_clear();
                lcd_gotoxy(0,0);
                lcd_puts("Enter Item:: ");
                continue;
            }
            lcd_gotoxy(13,0);
            lcd_putchar(key);
            delay_ms(10);
            editPrice(key);
            lcd_clear();
            lcd_gotoxy(0,0);
            lcd_puts("Enter Item:: ");

        }
        wait();

    }

}
void adminPanel(){
    lcd_clear();
    lcd_gotoxy(0,0);
    lcd_puts("Welcome Admin...");
    delay_ms(200);
    editItems();

}
unsigned char enterAdminPassword(){
    unsigned char tries=0;
    unsigned char key=0;
    unsigned char input[4];
    unsigned char i=0;
    lcd_clear();
    lcd_gotoxy(0,0);     
    lcd_puts("Admin Password:");
    lcd_gotoxy(0,1);

    while(1){
        key = getKey();
        if(key!=0){
            if(key=='#'){
                lcd_putchar('#');
                return 0;
            }
            input[i++]=key;
            lcd_putchar(key);

        }
        wait();

        if(i==3){
            input[3]='\0';
            if(strcmp(password,input)==0)
                return 1;      
            else{
                i=0;
                lcd_clear();
                lcd_gotoxy(0,0);     
                lcd_puts("Admin Password:");
                lcd_gotoxy(0,1);
                tries++;
            }
                 
        }
        if(tries==3){
         //enableAdminButton=0;
         return 0;
        }
          


    }





}
interrupt [EXT_INT0] void on_interrupt(){
    if(enableAdminButton==0)
        return;
    while(PIND.2);

    if(enterAdminPassword())
        adminPanel();
    mainScreen();

}

void init(void){
    int i;

    Keypad = 0X0F;
    Keypad_dir = 0X0F;
    PORTC = 0X00;
    DDRC = 0XFF;
    DDRB= 0XF0;
    PORTB=0X00;
    
    //-----------------
    DDRD=0X00;
    PORTD=0X00;
    
    #asm("SEI");
    GICR|=0X40;
    MCUCR=0x02;
    MCUCSR=0X00;
    GIFR=0X40;


    lcd_init(16);


}
void main(void){
    
    init();
    enableAdminButton=1;   
    mainScreen();
}