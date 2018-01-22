--���1����Ч�����ظ�
select a.c_emp_code,
       max(a.l_emp_id) as l_max_id,
       min(a.l_emp_id) as l_min_id,
       a.l_effective_date
  from dataedw.dim_pb_employee a
 group by a.c_emp_code, a.l_effective_date
having count(*) > 1;

--���2��ʧЧ�����ظ�
select a.c_emp_code,
       a.l_expiration_date,
       max(a.l_emp_id) as l_max_id,
       min(a.l_emp_id) as l_min_id
  from dataedw.dim_pb_employee a
 group by a.c_emp_code, a.l_expiration_date
having count(*) > 1;

--���3��������Ч���ڴ���ʧЧ����
select a.l_emp_id,
       a.c_emp_code,
       a.c_emp_name,
       a.l_effective_date,
       a.l_expiration_date,
       a.l_effective_flag
  from dataedw.dim_pb_employee a
 where a.l_effective_date >= a.l_expiration_date;
 
--���4�����ڴ��ڶ�����¼�ģ�ʧЧ��������Ч����֮����ڶϲ�


--���5��Ա����Ч����С�ڲ�����Ч���ڻ���Ա��ʧЧ���ڴ��ڲ���ʧЧ����
select a.l_emp_id,
       a.c_emp_code,
       a.c_emp_name,
       a.l_effective_date,
       a.l_expiration_date,
       a.l_effective_flag,
       a.l_dept_id,
       b.l_effective_date,
       b.l_expiration_date
  from dataedw.dim_pb_employee a, dataedw.dim_pb_department b
 where a.l_dept_id = b.l_dept_id
   and (a.l_effective_date < b.l_effective_date or
       a.l_expiration_date > b.l_expiration_date);
