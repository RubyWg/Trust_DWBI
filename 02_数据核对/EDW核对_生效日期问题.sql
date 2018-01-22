--��Ŀ��Ч����С�ڿ�ʼ����-δ���������仯ά�����
select a.l_setup_date,a.l_effective_date,a.*
  from dataedw.dim_pb_project_basic a
 where substr(a.l_setup_date,1,6) < substr(a.l_effective_date,1,6)
   and a.l_effective_flag = 1
   and not exists (select 1
          from dataedw.dim_pb_project_basic b
         where a.c_proj_code = b.c_proj_code
           and b.l_effective_flag = 0);

--��Ŀ��Ч�����ظ�          
select t.c_proj_code, t.l_effective_date
  from dataedw.dim_pb_project_basic t
 group by t.c_proj_code, t.l_effective_date
having count(*) > 1;

--��Ʒ��Ч����С�ڿ�ʼ����-δ���������仯ά�����
select a.l_setup_date,a.l_effective_date,a.*
  from dataedw.dim_pb_product a
 where substr(a.l_setup_date,1,6) < substr(a.l_effective_date,1,6)
   and a.l_effective_flag = 1
   and not exists (select 1
          from dataedw.dim_pb_product b
         where a.c_prod_code = b.c_prod_code
           and b.l_effective_flag = 0);

--��Ʒ��Ч�����ظ�
select t.c_prod_code, t.l_effective_date
  from dim_pb_product t
 group by t.c_prod_code, t.l_effective_date
having count(*) > 1;
           
--�ڴ���Ч����С�ڿ�ʼ����-δ���������仯ά�����
select a.l_setup_date,a.l_effective_date,a.*
  from dataedw.dim_sr_stage a
 where substr(a.l_setup_date,1,6) < substr(a.l_effective_date,1,6)
   and a.l_effective_flag = 1
   and not exists (select 1
          from dataedw.dim_sr_stage b
         where a.c_stage_code = b.c_stage_code
           and b.l_effective_flag = 0);

--�ڴ���Ч�����ظ�
select t.c_stage_code, t.l_effective_date
  from dim_sr_stage t
 group by t.c_stage_code, t.l_effective_date
having count(*) > 1;

--��ͬ��Ч����С�ڿ�ʼ����-δ���������仯ά�����
select a.l_begin_date,a.l_effective_date,a.*
  from dataedw.dim_tc_contract a
 where substr(a.l_begin_date,1,6) < substr(a.l_effective_date,1,6)
   and a.l_effective_flag = 1
   and not exists (select 1
          from dataedw.dim_tc_contract b
         where a.c_cont_code = b.c_cont_code
           and b.l_effective_flag = 0);

--��ͬ��Ч����С�ڿ�ʼ����-δ���������仯ά�����
select a.l_begin_date,a.l_effective_date,a.*
  from dataedw.dim_tc_contract a
 where substr(a.l_begin_date,1,6) < substr(a.l_effective_date,1,6)
   and a.l_effective_flag = 1
   and not exists (select 1
          from dataedw.dim_tc_contract b
         where a.c_cont_code = b.c_cont_code
           and b.l_effective_flag = 0);


--��ͬ��Ч����С�ڿ�ʼ����-δ���������仯ά�����
select a.l_begin_date,a.l_effective_date,a.*
  from dataedw.dim_tc_contract a
 where substr(a.l_begin_date,1,6) < substr(a.l_effective_date,1,6)
   and a.l_effective_flag = 1
   and not exists (select 1
          from dataedw.dim_tc_contract b
         where a.c_cont_code = b.c_cont_code
           and b.l_effective_flag = 0);

--������Ч����С�ڿ�ʼ����
select *
  from dataedw.dim_to_book t
 where substr(t.l_writeon_date,1,6) < substr(t.l_effective_date,1,6)
   and t.l_effective_flag = 1
   and not exists (select 1
          from dataedw.dim_to_book b
         where t.c_book_code = b.c_book_code
           and b.l_effective_flag = 0);
