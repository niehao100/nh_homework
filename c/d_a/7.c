#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#define _HASH_SIZE 2048
typedef struct _Book{
 char bno[16];
 char bname[100];
 char author[60];
 char ISBN[20];
 char class[28];
 char press[100];
 char publish_date[20];
 bool in;
 int time;
}book;
int size1[7]={0,16,116,176,196,224,324};
typedef struct _NODE{
		book* the_book;
		struct _NODE* next;
}node;

typedef struct _TABLE{
	node hash_bno[_HASH_SIZE];
	node hash_bname[_HASH_SIZE];
	node hash_author[_HASH_SIZE];
  node hash_ISBN[_HASH_SIZE];
	node hash_class[_HASH_SIZE];
	node hash_press[_HASH_SIZE];
  node hash_publish_date[_HASH_SIZE];
}table;

table hash_table;

//ELF hash函数,本部分的代码为通行的ELF
unsigned  int  ELFHash( char   * str)
  {
        unsigned  int  hash  =   0 ;
        unsigned  int  x     =   0 ;
         while  ( * str)
           {
                 hash  =  (hash  <<   4 )  +  ( * str ++ );
                  if  ((x  =  hash  &   0xF000000000000000L )  !=   0 )
                  {
                        hash  ^=  (x  >>   24 );
                        hash  &=   ~ x;
                } 
        } 
          return  (hash  &   0x7FFFFFFFFFFFFFFF );
} 

void Add(void){
	char s[65];
	int i=0,j=0;	
	unsigned int hash;
	book* b = (book*)malloc(sizeof(book));
	node* nb = NULL,*now=NULL;
		for(i=0;i<7;i++){
			scanf("%s",s);
			strcpy((char*)((int)b+size1[i]),s);
    }
  for(i=0;i<7;i++){
		nb=(node*)malloc(sizeof(node));
		nb->the_book=b;
		hash=(ELFHash((char*)((int)b+size1[i]))%_HASH_SIZE);
		now =& (((node*)((int)(&hash_table)+i*16*_HASH_SIZE))[hash]);
		for(;now->next;now=now->next);
		now->next=nb;
		nb->next=NULL;
	}
}

void Delete(char* str){
		char i=0;
		unsigned int hash=(ELFHash(str)%_HASH_SIZE);
		book* b=NULL;
		node* now = &(hash_table.hash_bno[hash]),*to_delete;
		for(;now->next;now=now->next){
				if(strcmp(now->next->the_book->bno,str)==0) {
					to_delete=now->next;
					b=now->next->the_book;
					break;
				}
		}
		if(b==NULL) return;
		now->next=to_delete->next;
		free(to_delete);
		for(i=1;i<7;i++){
			hash=(ELFHash(((char*)((int)b+size1[i])))%_HASH_SIZE);
			now =& (((node*)((int)(&hash_table)+i*16*_HASH_SIZE))[hash]);
			for(;now->next;now=now->next){
				if(strcmp(now->next->the_book->bno,str)==0) {
						to_delete=now->next;
						now->next=to_delete->next;
						free(to_delete);
						break;
				}
			}
		}
		free(b);
		return;
}

void lend(char* str,int time){
		char i=0;
		unsigned int hash=(ELFHash(str)%_HASH_SIZE);
		book* b=NULL;
		node* now = &(hash_table.hash_bno[hash]),*to_delete;
		for(;now->next;now=now->next){
				if(strcmp(now->next->the_book->bno,str)==0) {
					b=now->next->the_book;
					break;
				}
		}
		if(b==NULL) return;
		b->in=1; 
		b->time=time;
}

void guihuan(char * str){
		char i=0;
		unsigned int hash=(ELFHash(str)%_HASH_SIZE);
		book* b=NULL;
		node* now = &(hash_table.hash_bno[hash]),*to_delete;
		for(;now->next;now=now->next){
				if(strcmp(now->next->the_book->bno,str)==0) {
					b=now->next->the_book;
					break;
				}
		}
		if(b==NULL) return;
		b->in=0; 
}
book* search_stack[100];
char stack_flag=-1;
void search(char type,char* str){
		  unsigned int hash=(ELFHash(str)%_HASH_SIZE);
			node* now =& (((node*)((int)(&hash_table)+type*16*_HASH_SIZE))[hash]);
			
			for(;now->next;now=now->next){
				if(strcmp((char*)((int)(now->next->the_book)+size1[type]),str)==0) {
					stack_flag++; 
					search_stack[stack_flag]=now->next->the_book;
				}
			}
}

int main (void){
int time=0;
book* b=NULL;
char commond=0,type=0,s[100],i=0;
		for(;;){
			scanf("%c",&commond);
		  switch(commond){
				case 'q': return 0;
				case 'a': Add();break;
				case 'l':scanf("%s",s);
								 scanf("%d",&time);
								 lend(s,time);
								 break;
				case 'g':scanf("%s",s);
								 guihuan(s);
								 break;
				case 'd':scanf("%s",s);
								 Delete(s);
								 break;
				case 's':scanf("%d",&type);
								 scanf("%s",s);
								 scanf("%d",&time);
								 search(type,s);
								 if(stack_flag==-1) printf("-1\n");
								 for(;stack_flag>-1;stack_flag--){
										b=search_stack[stack_flag];
										printf("Book State:");
										switch(b->in){
											case 0: printf(" 0\n");
															break;
											case 1:if(time>(b->time+10))
																	 printf(" 2\n");
														 else{
															 printf(" 1 %d\n",(b->time+10));
														 }
														 break;
										}
										printf("Book Info:");
										for(i=0;i<7;i++)
										printf(" %s",(char*)((int)b+size1[i]));
										printf("\n");
								}
								 break;
						}
			}
}
