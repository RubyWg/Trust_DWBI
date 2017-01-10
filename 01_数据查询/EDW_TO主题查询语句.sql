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