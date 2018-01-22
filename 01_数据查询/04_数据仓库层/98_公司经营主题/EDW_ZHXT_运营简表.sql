--��Ӫ���
select null as ���ױ��,
       a.c_cont_code as ��ͬ����,
       a.c_cont_no as ��ͬ���,
       c.c_proj_name as ��Ŀ����,
       d.c_dept_name as ��������,
       f.c_manage_type_n as ��/����,
       e.f_balance_agg   as �������,
       e.f_decrease_agg  as �ۼƻ���,
       decode(b.c_struct_type,'0',e.f_balance_agg,null ) as ����,
       decode(b.c_struct_type,'2',e.f_balance_agg,null ) as �Ӻ�,
       a.l_sign_date as ��ͬ���ʱ��,
       a.l_expiry_date as ��ͬ��ֹʱ��,
       null as ʵ�����б�����,
       null as ��ͬ������,
       null as ����Ӧ��������,
       null as ��δ��������,
       null as ���б�������,
       null as ��ͬ�����������
  from dim_tc_contract      a,
       dim_pb_product       b,
       dim_pb_project_basic c,
       dim_pb_department    d,
       tt_tc_scale_cont_m   e,
       dim_pb_project_biz   f
 where a.l_prod_id = b.l_prod_id
   and b.l_proj_id = c.l_proj_id
   and c.l_dept_id = d.l_dept_id
   and a.l_cont_id = e.l_cont_id
   and b.l_proj_id = f.l_proj_id
   and substr(a.l_effective_date, 1, 6) <= e.l_month_id
   and substr(a.l_expiry_date, 1, 6) > e.l_month_id
   and e.l_month_id = 201609;

--������ͬ����
select d.c_proj_code, d.c_proj_name, sum(a.f_planned_agg)/10000
  from tt_ic_ie_prod_m      a,
       dim_pb_ie_type       b,
       dim_pb_ie_status     c,
       dim_pb_project_basic d
 where a.l_ietype_id = b.l_ietype_id
   and a.l_iestatus_id = c.l_iestatus_id
   and a.l_proj_id = d.l_proj_id
   and c.c_iestatus_code = 'NEW'
   and a.l_month_id = 201612
   and substr(d.l_effective_date, 1, 6) <= a.l_month_id
   and substr(d.l_expiration_date, 1, 6) > a.l_month_id
 group by d.c_proj_code, d.c_proj_name;