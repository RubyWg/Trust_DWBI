create or replace view v_pb_proj_info as
select pb1.l_proj_id,
       pb3.l_prod_id,
       pb1.c_proj_code          as "��Ŀ���(TCMP)",
       pb1.c_name_full          as "��Ŀ����(TCMP)",
       pb4.c_dept_name          as "ҵ����(TCMP)",
       pb2.c_manage_type_n      as "��Ŀ��������(TCMP)",
       pb2.c_proj_type_n        as "��Ŀ����(TCMP)",
       pb2.c_func_type_n        as "��Ŀ���ܷ���(BULU)",
       pb2.c_invest_indus_n     as "��Ŀʵ��Ͷ��(BULU)",
       to_date(pb1.l_setup_date, 'yyyymmdd')                as "��Ŀ��ʼ����(TCMP)",
       to_date(pb1.l_expiry_date, 'yyyymmdd')               as "��Ŀ��ֹ����(TCMP)",
       to_date(pb1.l_preexp_date, 'yyyymmdd')               as "��ĿԤ�Ƶ���(TCMP)",
       case when nvl(substr(pb1.l_expiry_date, 1, 6), 209912) > 201707 then  '����' else '����' end as "��Ŀ״̬(TCMP)",
       decode(pb2.l_pool_flag, 0, '��', 1, '��', null)  as "�Ƿ��ʽ��(BULU)",
       decode(pb2.c_special_type, 'A', '��', '��')      as "�ջݽ���(TCMP)",
       decode(pb2.l_pitch_flag, 0, '��', 1, '��', null) as "�Ƿ��ڳ���(TCMP)",
       decode(pb2.l_openend_flag, 0, '��', 1, '��', null) as "�Ƿ񿪷�ʽ(TCMP)"
  from dim_pb_project_basic pb1,
       dim_pb_project_biz   pb2,
       dim_pb_product       pb3,
       dim_pb_department    pb4
 where pb1.l_proj_id = pb2.l_proj_id
   and pb1.l_setup_date <= 20170731
   and substr(pb1.l_Effective_Date, 1, 6) <= 201707
   and substr(pb1.l_expiration_date, 1, 6) > 201707
   and pb1.l_proj_id = pb3.l_proj_id
   and pb1.l_dept_id = pb4.l_dept_id;
