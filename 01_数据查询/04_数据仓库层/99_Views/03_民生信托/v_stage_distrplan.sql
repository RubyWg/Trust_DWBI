create or replace view v_stage_distrplan as
select td.c_projectcode,
         td.c_stagescode,
         td.l_period,
         td.d_plandate,
         td.f_calcbase,                  --������
         td.f_rate,                      --������
         td.c_rpclass,
         td.f_money,
         td.l_writeoff
from dataods.tta_distrplan td;
