#ifndef FILTER_H
#define FILTER_H
typedef struct
{
    int           angle;   /* centi-degree */
    unsigned char init;
} CompFilter;
void Filter_Init(CompFilter *f);
int  Filter_Update(CompFilter *f, int acc_cdeg, int gyro_dcdeg);
#endif
