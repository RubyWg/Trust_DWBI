--��Ӫָ��
select a.c_indic_code,
       a.c_indic_name,
       b.f_indic_actual as ʵ��ֵ,
       b.f_indic_budget as Ԥ��ֵ,
       b.f_indic_change as �仯ֵ
  from dim_op_indicator a, tt_op_indicator_m b
 where a.l_indic_id = b.l_indic_id
   and b.l_month_id = 201611;

--�Զ��屨��-�̶�����ִ�����
--��������
select a.c_item_code, a.c_item_name, c.f_value1 as ʵ��, c.f_value2 as Ԥ��
  from dim_op_report_item a, dim_op_report b, tt_op_report_m c
 where a.l_report_id = b.l_report_id
   and a.l_item_id = c.l_item_id
   and b.c_report_code = 'GDFYZXQK'
   and c.l_month_id = 201610;
   
--�Զ��屨��-������
--��������
select a.c_item_code,
       a.c_item_name,
       c.f_value1    as ���귢��ֵ,
       c.f_value2    as ���·���ֵ,
       c.f_value3    as ����Ԥ��ֵ
  from dim_op_report_item a, dim_op_report b, tt_op_report_m c
 where a.l_report_id = b.l_report_id
   and a.l_item_id = c.l_item_id
   and b.c_report_code = 'LRJB'
   and c.l_month_id = 201611;