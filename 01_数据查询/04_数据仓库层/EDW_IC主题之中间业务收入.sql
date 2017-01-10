--�м�ҵ������
select c.c_revtype_name, sum(a.f_midrev_int_eot)
  from tt_ic_midrev_proj_m a, dim_pb_project_basic b, dim_sr_revenue_type c
 where a.l_proj_id = b.l_proj_id
   and a.l_revtype_id = c.l_revtype_id
   and substr(B.L_EFFECTIVE_DATE, 1, 6) <= A.L_MONTH_ID
   and substr(B.L_EXPIRATION_DATE, 1, 6) > A.L_MONTH_ID
   and a.l_month_id = 201606
 group by c.c_revtype_name;

--������Ŀ�м�ҵ��������ˮ
select b.c_proj_code, b.c_proj_name, c.c_revtype_name, a.*
  from tt_ic_revenue_flow_d a,
       dim_pb_project_basic b,
       dim_sr_revenue_type  c
 where a.l_proj_id = b.l_proj_id
   and a.l_revtype_id = c.l_revtype_id
   and b.c_proj_code = 'EA42'
 order by c.c_revtype_name, l_revdate_id; 

--�����ֹ�Ԥ��ֵ
select a.c_item_code, a.c_item_name, B.F_ACTUAL
  from dim_pb_budget_item a, tt_pb_budget_y b
 where A.L_ITEM_ID = B.L_ITEM_ID
   and A.C_ITEM_CODE in ('JYGS0011', 'JYGS0012', 'JYGS0013', 'JYGS0014')
   and b.l_year_id = 2016;
   
--�м�ҵ�����밴����
select d.l_dept_id, d.c_dept_Name,
round(sum(decode(c.c_revtype_name,'�м䱣�ܷ�',a.f_midrev_int_eot,0))/10000,2) �м䱣�ܷ�,
round(sum(decode(c.c_revtype_name,'�м�ƹ˷�',a.f_midrev_int_eot,0))/10000,2) �м�ƹ˷�,
round(sum(decode(c.c_revtype_name,'�м䷢�з�',a.f_midrev_int_eot,0))/10000,2) �м䷢�з�,
round(sum(decode(c.c_revtype_name,'�м�����',a.f_midrev_int_eot,0))/10000,2) �м�����
  from tt_ic_midrev_proj_m  a,
       dim_pb_project_basic b,
       dim_sr_revenue_type  c,
       dim_pb_department    d
 where a.l_proj_id = b.l_proj_id
   and a.l_revtype_id = c.l_revtype_id
   and b.l_dept_id = d.l_dept_id
   and substr(B.L_EFFECTIVE_DATE, 1, 6) <= A.L_MONTH_ID
   and substr(B.L_EXPIRATION_DATE, 1, 6) > A.L_MONTH_ID
   and a.l_month_id = 201608
 group by d.l_dept_id, d.c_dept_Name
 order by d.l_dept_id, d.c_dept_Name;

--ָ������ָ���м�����
select b.c_proj_code,
       b.c_proj_name,
       c.c_revtype_name,
       round(sum(a.f_midrev_int_eot) / 10000, 2)
  from tt_ic_midrev_proj_m  a,
       dim_pb_project_basic b,
       dim_sr_revenue_type  c,
       dim_pb_department    d
 where a.l_proj_id = b.l_proj_id
   and a.l_revtype_id = c.l_revtype_id
   and b.l_dept_id = d.l_dept_id
   and d.c_dept_name = '����ҵ��һ��'
   and substr(B.L_EFFECTIVE_DATE, 1, 6) <= A.L_MONTH_ID
   and substr(B.L_EXPIRATION_DATE, 1, 6) > A.L_MONTH_ID
   and a.l_month_id = 201608
   and c.c_revtype_name = '�м䱣�ܷ�'
 group by b.c_proj_code, b.c_proj_name, c.c_revtype_name
having sum(a.f_midrev_int_eot) <> 0;