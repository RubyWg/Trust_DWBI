--���1����Ч�����ظ�
select a.c_proj_code,
       max(a.l_proj_id) as l_max_id,
       min(a.l_proj_id) as l_min_id,
       a.l_effective_date
  from dataedw.dim_pb_project_basic a
 group by a.c_proj_code, a.l_effective_date
having count(*) > 1;

--���2��ʧЧ�����ظ�
select a.c_proj_code,
       a.l_expiration_date,
       max(a.l_proj_id) as l_max_id,
       min(a.l_proj_id) as l_min_id
  from dataedw.dim_pb_project_basic a
 group by a.c_proj_code, a.l_expiration_date
having count(*) > 1;

--���3��������Ч���ڴ���ʧЧ����
select a.l_proj_id,
       a.c_proj_code,
       a.c_proj_name,
       a.l_effective_date,
       a.l_expiration_date,
       a.l_effective_flag
  from dataedw.dim_pb_project_basic a
 where a.l_effective_date >= a.l_expiration_date;
 

--���5����Ŀ��Ч����С�ڲ�����Ч���ڻ���ʧЧ���ڴ��ڲ���ʧЧ����
select a.l_proj_id,
       a.c_proj_code,
       a.c_proj_name,
       a.l_effective_date,
       a.l_expiration_date,
       a.l_effective_flag,
       a.l_dept_id,
       b.l_effective_date,
       b.l_expiration_date
  from dataedw.dim_pb_project_basic a, dataedw.dim_pb_department b
 where a.l_dept_id = b.l_dept_id
   and (a.l_effective_date < b.l_effective_date or
       a.l_expiration_date > b.l_expiration_date);
