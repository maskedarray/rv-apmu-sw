
#define counter_read(rd, rs1)       asm volatile ("cnt.rd\t%0,%1" : "=r" (rd) : "r" (rs1));
int main(){
    counter_read2();
    return 0;    
}

int counter_read2(){
        int a = 2;
    int b = 1;
    int c = a+b;
    int d;
    counter_read(d, c);
    return d;
}