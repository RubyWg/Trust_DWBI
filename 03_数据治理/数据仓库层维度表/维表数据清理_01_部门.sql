--���1����Ч�����ظ�
select a.c_dept_code,
       max(a.l_dept_id) as l_max_id,
       min(a.l_dept_id) as l_min_id,
       a.l_effective_date
  from dataedw.dim_Pb_department a
 group by a.c_dept_code, a.l_effective_date
having count(*) > 1;

--���2��ʧЧ�����ظ�
select a.c_dept_code,
       a.l_expiration_date,
       max(a.l_dept_id) as l_max_id,
       min(a.l_dept_id) as l_min_id
  from dataedw.dim_Pb_department a
 group by a.c_dept_code, a.l_expiration_date
having count(*) > 1;

--���3��������Ч���ڴ���ʧЧ����
select *
  from dataedw.dim_pb_department a
 where a.l_effective_date >= a.l_expiration_date;

--���4�����ڴ��ڶ�����¼�ģ�ʧЧ��������Ч����֮����ڶϲ�


select * from dataedw.dim_pb_department t where t.l_dept_id in (34,74)
