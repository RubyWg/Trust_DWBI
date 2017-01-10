--�ʹ�����Ͷ������
select b.c_proj_code     as ��Ŀ����,
       b.c_name_full     as ��Ŀ����,
       a.c_book_code     as ���ױ���,
       a.c_book_name     as ��������,
       a.c_invest_type_n as ����Ͷ������,
       a.c_book_type_n   as ��������
  from dim_to_book a, dim_pb_project_basic b, dim_pb_department c
 where a.l_proj_id = b.l_proj_id
   and a.l_effective_flag = 1
   and b.l_dept_id = c.l_dept_id
   --and c.c_dept_code = '841'
 order by b.c_proj_code;

--��ֵ��ģ--������
select c.c_manage_type_n, round(sum(b.f_balance_agg)/100000000,2)
  from dim_pb_project_basic   a,
       tt_to_operating_book_m b,
       dim_pb_project_biz     c 
 where a.l_proj_id = b.l_proj_id
   and a.l_proj_id = c.l_proj_id
   and b.l_month_id = 201611
   and b.f_balance_agg <> 0
   and a.l_effective_flag = 1 --and nvl(a.l_expiry_date,20991231) > 20161130 
 group by c.c_manage_type_n;
 
--��ֵ��ģ--��Ŀ����
select c.c_proj_type_n, round(sum(b.f_balance_agg)/100000000,2)
  from dim_pb_project_basic   a,
       tt_to_operating_book_m b,
       dim_pb_project_biz     c 
 where a.l_proj_id = b.l_proj_id
   and a.l_proj_id = c.l_proj_id
   and b.l_month_id = 201611
   and b.f_balance_agg <> 0
   and a.l_effective_flag = 1 --and nvl(a.l_expiry_date,20991231) > 20161130 
 group by c.c_proj_type_n;

--��ֵ��ģ--���ܷ���
select c.c_func_type_n, round(sum(b.f_balance_agg)/100000000,2)
  from dim_pb_project_basic   a,
       tt_to_operating_book_m b,
       dim_pb_project_biz     c
 where a.l_proj_id = b.l_proj_id
   and a.l_proj_id = c.l_proj_id
   and b.l_month_id = 201611
   and b.f_balance_agg <> 0
   and a.l_effective_flag = 1 --and nvl(a.l_expiry_date,20991231) > 20161130 
 group by c.c_func_type_n;

--�������׵�ʵ������ 
select b.l_subj_id,b.c_subj_code,b.c_subj_name,a.*
  from tt_to_accounting_subj_m a, dim_to_subject b
 where a.l_book_id = b.l_book_id
   and a.l_subj_id = b.l_subj_id
   and a.l_book_id = 515
   and a.l_month_id = 201611
   and b.c_subj_code like '4001%';

--��ֵ-�ʽ�Ͷ����ҵ
select d.c_proj_code,
       d.c_proj_name,
       sum(decode(b.c_invest_indus, 'HYTX_JCCY', a.f_balance_agg, 0)) as ������ҵ,
       sum(decode(b.c_invest_indus, 'HYTX_FDC', a.f_balance_agg, 0)) as ���ز�,
       sum(decode(b.c_invest_indus, 'HYTX_ZQ', a.f_balance_agg, 0)) as ֤ȯ,
       sum(decode(b.c_invest_indus, 'HYTX_JRJG', a.f_balance_agg, 0)) as ���ڻ���,
       sum(decode(b.c_invest_indus, 'HYTX_GSQY', a.f_balance_agg, 0)) as ������ҵ,
       sum(decode(b.c_invest_indus, 'HYTX_QT', a.f_balance_agg, 0)) as ����
  from tt_to_accounting_subj_m a,
       dim_to_subject          b,
       dim_pb_project_basic    d
 where a.l_subj_id = b.l_subj_id
   and a.l_book_id = b.l_book_id
   and a.l_proj_id = d.l_proj_id
   and d.l_effective_flag = 1
   and a.l_month_id = 201611
 group by d.c_proj_code, d.c_proj_name;

--��ֵ-�ʽ����÷�ʽ
select d.c_proj_code,
       d.c_proj_name,
       sum(decode(b.c_fduse_way, 'YYFS_DK', a.f_balance_agg, 0)) as ����,
       sum(decode(b.c_fduse_way, 'YYFS_JYXJRZC', a.f_balance_agg, 0)) as �����Խ����ʲ�,
       sum(decode(b.c_fduse_way, 'YYFS_KGCSJCYZDQ', a.f_balance_agg, 0)) as �ɹ����ۼ�����������,
       sum(decode(b.c_fduse_way, 'YYFS_GQTZ', a.f_balance_agg, 0)) as ��ȨͶ��,
       sum(decode(b.c_fduse_way, 'YYFS_ZL', a.f_balance_agg, 0)) as ����,
       sum(decode(b.c_fduse_way, 'YYFS_MRFS', a.f_balance_agg, 0)) as ���뷵��,
       sum(decode(b.c_fduse_way, 'YYFS_CC', a.f_balance_agg, 0)) as ���,
       sum(decode(b.c_fduse_way, 'YYFS_CFTY', a.f_balance_agg, 0)) as ���ͬҵ,
       sum(decode(b.c_fduse_way, 'YYFS_QT', a.f_balance_agg, 0)) as ����
  from tt_to_accounting_subj_m a, dim_to_subject b, dim_pb_project_basic d
 where a.l_subj_id = b.l_subj_id
   and a.l_book_id = b.l_book_id
   and a.l_proj_id = d.l_proj_id
   and d.l_effective_flag = 1
   and a.l_month_id = 201611
 group by d.c_proj_code, d.c_proj_name;
 
--������ֹ��Ŀ��Ӫ��ϸ
select c.c_book_code   as ���ױ���,
       b.c_proj_code   as ��Ŀ����,
       b.c_proj_name   as ��Ŀ����,
       b.l_setup_date  as ��Ŀ��������,
       b.l_expiry_date as ��Ŀ��ֹ����,
       a.f_days_agg    as ��Ŀ��������,
       a.f_scale_agg   as ʵ������,
       a.f_scale_ad    as �վ���ģ,
       a.f_cost_agg    as �ۼ����з���,
       a.f_income_agg  as �ۼ�����������,
       a.f_pay_agg     as �ۼ������˱���
  from tt_to_operating_book_m a,
       dim_pb_project_basic   b,
       dim_to_book            c,
       tt_pb_object_status_m  d,
       dim_pb_object_status   e
 where a.l_proj_id = b.l_proj_id
   and a.l_book_id = c.l_book_id
   and b.l_proj_id = d.l_object_id
   and d.c_object_type = 'XM'
   and d.l_objstatus_id = e.l_objstatus_id
   and e.l_expiry_ty_flag = 1
   and a.l_month_id = d.l_month_id
   and b.l_effective_flag = 1
   and a.l_month_id = 201610
-- and c.c_book_code = '100611'
--and nvl(b.l_expiry_date, 20991231) between 20160101 and 20161031
 order by c.c_book_code; 
 
--��ֹ��Ŀ���²��������б���
select substr(b.l_expiry_date, 1, 6),
       round(sum(a.f_pay_agg * 365) / sum(a.f_days_agg * a.f_scale_agg), 6)
  from tt_to_operating_book_m a,
       dim_pb_project_basic   b,
       dim_to_book            c,
       tt_pb_object_status_m  d,
       dim_pb_object_status   e
 where a.l_proj_id = b.l_proj_id
   and a.l_book_id = c.l_book_id
   and b.l_proj_id = d.l_object_id
   and d.l_objstatus_id = e.l_objstatus_id
   and d.c_object_type = 'XM'
   and a.l_month_id = d.l_month_id
   and a.l_month_id = 201610
   and b.l_effective_flag = 1
   and e.l_expiry_ty_flag = 1
 group by substr(b.l_expiry_date, 1, 6)
 order by substr(b.l_expiry_date, 1, 6);

--������Ŀ����,��ģ
select b.c_special_type_n, count(*), sum(c.f_balance_agg) / 100000000
  from dim_pb_project_basic   a,
       dim_pb_project_biz     b,
       tt_to_operating_book_m c
 where a.l_proj_id = b.l_proj_id
   and a.l_proj_id = c.l_proj_id
   and c.l_month_id = 201611
   and a.l_effective_flag = 1
   and nvl(b.c_special_type, '99') <> '99'
 group by b.c_special_type_n;
 
--������Ŀ��ģ-������
select c.c_dept_cate_n,c.c_dept_name, sum(b.f_balance_agg)
  from dim_pb_project_basic   a,
       tt_to_operating_book_m b,
       dim_pb_department      c
 where a.l_proj_id = b.l_proj_id
   and a.l_dept_id = c.l_dept_id
   and b.l_month_id = 201611
   and b.f_balance_agg <> 0
   and a.l_effective_flag = 1
   and c.c_dept_cate = '04'--�к�̨ҵ����
 group by c.c_dept_cate_n,c.c_dept_name;