--���1����Ч�����ظ�
select a.c_prod_code,
       max(a.l_prod_id) as l_max_id,
       min(a.l_prod_id) as l_min_id,
       a.l_effective_date
  from dataedw.dim_pb_product a
 group by a.c_prod_code, a.l_effective_date
having count(*) > 1;

--���2��ʧЧ�����ظ�
select a.c_prod_code,
       a.l_expiration_date,
       max(a.l_prod_id) as l_max_id,
       min(a.l_prod_id) as l_min_id
  from dataedw.dim_pb_product a
 group by a.c_prod_code, a.l_expiration_date
having count(*) > 1;

--���3��������Ч���ڴ���ʧЧ����
select *
  from dataedw.dim_pb_product a
 where a.l_effective_date >= a.l_expiration_date;


--���5����Ʒ��Ч����С����Ŀ��Ч���ڻ���ʧЧ���ڴ�����ĿʧЧ����
select a.l_prod_id,
       a.c_prod_code,
       a.c_prod_name,
       a.l_effective_date,
       a.l_expiration_date,
       a.l_effective_flag,
       a.l_proj_id,
       b.l_effective_date,
       b.l_expiration_date
  from dataedw.dim_pb_product a, dataedw.dim_pb_project_basic b
 where a.l_proj_id = b.l_proj_id
   and (a.l_effective_date < b.l_effective_date or
       a.l_expiration_date > b.l_expiration_date);
