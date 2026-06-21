/*============================================================================
  filter.c  -  Complementary filter SO NGUYEN (centi-degree)
  angle = (NUM*(angle+gyro_delta) + (DEN-NUM)*acc) / DEN
============================================================================*/
#include "config.h"
#include "filter.h"

void Filter_Init(CompFilter *f)
{
    f->angle = 0;
    f->init  = 0;
}

int Filter_Update(CompFilter *f, int acc_cdeg, int gyro_dcdeg)
{
    long pred;
    if (!f->init)
    {
        f->angle = acc_cdeg;
        f->init  = 1;
        return f->angle;
    }
    pred = (long)f->angle + gyro_dcdeg;
    f->angle = (int)(( (long)COMP_ALPHA_NUM * pred +
                       (long)(COMP_ALPHA_DEN - COMP_ALPHA_NUM) * acc_cdeg )
                     / COMP_ALPHA_DEN);
    return f->angle;
}
