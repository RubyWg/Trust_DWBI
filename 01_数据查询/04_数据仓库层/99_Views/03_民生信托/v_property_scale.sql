create or replace view v_property_scale as
select a.c_stagescode,d.d_date,
       sum(case when to_char(a.d_varydate,'yyyy') < to_char(d.d_date,'yyyy') then a.f_scale else 0end) as f_balance_ly,--���������ģ
       sum(a.f_scale) as f_balance,--��ǰ��ģ���
       sum(case when a.c_busiflag = '62' and to_char(a.d_varydate,'yyyy') = to_char(d.d_date,'yyyy') then a.f_scale else 0end) as f_bridge, --������Ź�ģ
       sum(case when to_char(b.d_setup,'yyyy') = to_char(d.d_date,'yyyy') then a.f_scale else 0end) as f_net_increase,--������ģ
       sum(case when to_char(a.d_varydate,'yyyy') = to_char(d.d_date,'yyyy') and a.f_scale > 0 then a.f_scale else 0end) as f_increase,--������ģ
       sum(case when to_char(a.d_varydate,'yyyy') = to_char(d.d_date,'yyyy') and a.f_scale < 0 then a.f_scale*-1 else 0end) as f_decrease --�����ģ
  from dataods.tta_saclevary  a,
       dataods.tpm_stagesinfo b,
       dataods.tprojectinfo   c,
       dataods.topenday       d
 where a.c_stagescode = b.c_stagescode
   and b.c_projectcode = c.c_projectcode
   and a.d_varydate <= d.d_date
   and c.c_propertytype_indiv = '1'
   and b.l_period <> 0
   group by a.c_stagescode,d.d_date;
