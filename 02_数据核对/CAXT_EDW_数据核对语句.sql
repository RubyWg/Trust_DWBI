--�Զ��屨��������
--��Ӫָ��
select a.c_indic_code,
       a.c_indic_name,
       b.f_indic_actual as ʵ��ֵ,
       b.f_indic_budget as Ԥ��ֵ,
       b.f_indic_change as �仯ֵ
  from dim_op_indicator a, tt_op_indicator_m b
 where a.l_indic_id = b.l_indic_id
   and b.l_month_id = 201612;

--������ģ
select count(*),
       sum(a.f_balance_eot)/100000000
  from tt_sr_scale_proj_m    a,
       dim_pb_project_biz    b,
       dim_pb_object_status  c,
       tt_pb_object_status_m d,
       dim_pb_project_basic  e
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = d.l_object_id
   and d.c_object_type = 'XM'
   and c.l_objstatus_id = d.l_objstatus_id
   and c.l_exist_tm_flag = 1
   and b.l_proj_id = e.l_proj_id
   and a.l_month_id = d.l_month_id
   and a.l_month_id = 201612
   and substr(e.l_effective_date,1,6) <= a.l_month_id
   and substr(e.l_expiration_date,1,6)>a.l_month_id;  
   
--������Ŀ������ģ������Ŀ����
select b.c_proj_type_n,
       count(*),
       sum(a.f_balance_eot)/100000000
  from tt_sr_scale_proj_m    a,
       dim_pb_project_biz    b,
       dim_pb_object_status  c,
       tt_pb_object_status_m d,
       dim_pb_project_basic  e
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = d.l_object_id
   and d.c_object_type = 'XM'
   and c.l_objstatus_id = d.l_objstatus_id
   and c.l_exist_tm_flag = 1
   and b.l_proj_id = e.l_proj_id
   and a.l_month_id = d.l_month_id
   and a.l_month_id = 201612
   and substr(e.l_effective_date,1,6) <= a.l_month_id
   and substr(e.l_expiration_date,1,6)>a.l_month_id
 group by b.c_proj_type_n
 order by b.c_proj_type_n;

--������Ŀ������ģ�������ܷ���
select b.c_func_type_n,
       count(*),
       sum(a.f_balance_eot)/100000000
  from tt_sr_scale_proj_m    a,
       dim_pb_project_biz    b,
       dim_pb_object_status  c,
       tt_pb_object_status_m d,
       dim_pb_project_basic  e
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = d.l_object_id
   and d.c_object_type = 'XM'
   and c.l_objstatus_id = d.l_objstatus_id
   and c.l_exist_tm_flag = 1
   and b.l_proj_id = e.l_proj_id
   and a.l_month_id = d.l_month_id
   and a.l_month_id = 201612
   and substr(e.l_effective_date,1,6) <= a.l_month_id
   and substr(e.l_expiration_date,1,6)>a.l_month_id
 group by b.c_func_type_n
 order by b.c_func_type_n;

--����ҵ�����밴ҵ��Χ
select c.c_busi_scope_n, round(sum(a.f_actual_eot) / 10000, 2)
  from tt_sr_tstrev_proj_m a, dim_pb_project_basic b, dim_pb_project_biz c
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = C.L_PROJ_ID
   and a.l_month_id >= substr(b.l_effective_date, 1, 6)
   and a.l_month_id < substr(b.l_expiration_date, 1, 6)
   and a.l_month_id = 201612
 group by c.c_busi_scope_n
having round(sum(a.f_planned_eot) / 10000, 2) <> 0
 order by c.c_busi_scope_n;
 
--����ҵ�����밴ҵ��Χ����Ŀ���͡����ܷ��ࡢ��������
select c.c_proj_type_n,
       round(sum(a.f_actual_eot) / 10000, 2)
  from tt_sr_tstrev_proj_m a, dim_pb_project_basic b, dim_pb_project_biz c
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = C.L_PROJ_ID
   and a.l_month_id >= substr(b.l_effective_date, 1, 6)
   and a.l_month_id < substr(b.l_expiration_date, 1, 6)
   and a.l_month_id = 201612
 group by c.c_proj_type_n
having round(sum(a.f_planned_eot) / 10000, 2) <> 0
 order by c.c_proj_type_n;
 
--����ҵ�����밴ҵ��Χ����Ŀ���͡����ܷ��ࡢ��������
select c.c_func_type_n,
       round(sum(a.f_actual_eot) / 10000, 2)
  from tt_sr_tstrev_proj_m a, dim_pb_project_basic b, dim_pb_project_biz c
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = C.L_PROJ_ID
   and a.l_month_id >= substr(b.l_effective_date, 1, 6)
   and a.l_month_id < substr(b.l_expiration_date, 1, 6)
   and a.l_month_id = 201612
 group by  c.c_func_type_n
having round(sum(a.f_planned_eot) / 10000, 2) <> 0
 order by c.c_func_type_n;

--��ֵ�ʽ�Ͷ����ҵ
select sum(decode(b.c_invest_indus, 'HYTX_JCCY', a.f_balance_agg, 0))/100000000 as ������ҵ,
       sum(decode(b.c_invest_indus, 'HYTX_FDC', a.f_balance_agg, 0))/100000000 as ���ز�,
       sum(decode(b.c_invest_indus, 'HYTX_ZQ', a.f_balance_agg, 0))/100000000 as ֤ȯ,
       sum(decode(b.c_invest_indus, 'HYTX_JRJG', a.f_balance_agg, 0))/100000000 as ���ڻ���,
       sum(decode(b.c_invest_indus, 'HYTX_GSQY', a.f_balance_agg, 0))/100000000 as ������ҵ,
       sum(decode(b.c_invest_indus, 'HYTX_QT', a.f_balance_agg, 0))/100000000 as ����
  from tt_to_accounting_subj_m a, dim_to_subject b, dim_pb_project_basic d
 where a.l_subj_id = b.l_subj_id
   and a.l_book_id = b.l_book_id
   and a.l_proj_id = d.l_proj_id
   and d.l_effective_flag = 1
   and a.l_month_id = 201612
   and substr(d.l_effective_date, 1, 6) <= a.l_month_id
   and substr(d.l_expiration_date, 1, 6) > a.l_month_id;

--��ֵ�ʽ����÷�ʽ
select sum(decode(b.c_fduse_way, 'YYFS_DK', a.f_balance_agg, 0))/100000000 as ����,
       sum(decode(b.c_fduse_way, 'YYFS_JYXJRZC', a.f_balance_agg, 0))/100000000 as �����Խ����ʲ�,
       sum(decode(b.c_fduse_way, 'YYFS_KGCSJCYZDQ', a.f_balance_agg, 0))/100000000 as �ɹ����ۼ�����������,
       sum(decode(b.c_fduse_way, 'YYFS_GQTZ', a.f_balance_agg, 0))/100000000 as ��ȨͶ��,
       sum(decode(b.c_fduse_way, 'YYFS_ZL', a.f_balance_agg, 0))/100000000 as ����,
       sum(decode(b.c_fduse_way, 'YYFS_MRFS', a.f_balance_agg, 0))/100000000 as ���뷵��,
       sum(decode(b.c_fduse_way, 'YYFS_CC', a.f_balance_agg, 0))/100000000 as ���,
       sum(decode(b.c_fduse_way, 'YYFS_CFTY', a.f_balance_agg, 0))/100000000 as ���ͬҵ,
       sum(decode(b.c_fduse_way, 'YYFS_QT', a.f_balance_agg, 0))/100000000 as ����
  from tt_to_accounting_subj_m a, dim_to_subject b, dim_pb_project_basic d
 where a.l_subj_id = b.l_subj_id
   and a.l_book_id = b.l_book_id
   and a.l_proj_id = d.l_proj_id
   and d.l_effective_flag = 1
   and a.l_month_id = 201612
   and substr(d.l_effective_date, 1, 6) <= a.l_month_id
   and substr(d.l_expiration_date, 1, 6) > a.l_month_id;

--����������ģ
select count(*),
       sum(a.f_increase_eot)/100000000
  from tt_sr_scale_proj_m    a,
       dim_pb_project_biz    b,
       dim_pb_object_status  c,
       tt_pb_object_status_m d,
       dim_pb_project_basic  e
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = d.l_object_id
   and d.c_object_type = 'XM'
   and c.l_objstatus_id = d.l_objstatus_id
   and c.l_setup_ty_flag = 1
   and b.l_proj_id = e.l_proj_id
   and a.l_month_id = d.l_month_id
   and a.l_month_id = 201612
   and substr(e.l_effective_date,1,6) <= a.l_month_id
   and substr(e.l_expiration_date,1,6)>a.l_month_id;  
   
--������Ŀ������ģ������Ŀ����
select b.c_proj_type_n,
       count(*),
       sum(a.f_increase_eot)/100000000
  from tt_sr_scale_proj_m    a,
       dim_pb_project_biz    b,
       dim_pb_object_status  c,
       tt_pb_object_status_m d,
       dim_pb_project_basic  e
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = d.l_object_id
   and d.c_object_type = 'XM'
   and c.l_objstatus_id = d.l_objstatus_id
   and c.l_setup_ty_flag = 1
   and b.l_proj_id = e.l_proj_id
   and a.l_month_id = d.l_month_id
   and a.l_month_id = 201612
   and substr(e.l_effective_date,1,6) <= a.l_month_id
   and substr(e.l_expiration_date,1,6)>a.l_month_id
 group by b.c_proj_type_n
 order by b.c_proj_type_n;

--������Ŀ������ģ�������ܷ���
select b.c_func_type_n,
       count(*),
       sum(a.f_increase_eot)/100000000
  from tt_sr_scale_proj_m    a,
       dim_pb_project_biz    b,
       dim_pb_object_status  c,
       tt_pb_object_status_m d,
       dim_pb_project_basic  e
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = d.l_object_id
   and d.c_object_type = 'XM'
   and c.l_objstatus_id = d.l_objstatus_id
   and c.l_setup_ty_flag = 1
   and b.l_proj_id = e.l_proj_id
   and a.l_month_id = d.l_month_id
   and a.l_month_id = 201612
   and substr(e.l_effective_date,1,6) <= a.l_month_id
   and substr(e.l_expiration_date,1,6)>a.l_month_id
 group by b.c_func_type_n
 order by b.c_func_type_n;
 
--��������ҵ�����밴ҵ��Χ
select c.c_busi_scope_n,
       round(sum(a.f_actual_eot) / 10000, 2)
  from tt_sr_tstrev_proj_m  a,
       dim_pb_project_basic b,
       dim_pb_project_biz   c,
       dim_pb_ie_status     d
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = C.L_PROJ_ID
   and a.l_revstatus_id = d.l_iestatus_id
   and d.c_iestatus_code = 'NEW'
   and a.l_month_id >= substr(b.l_effective_date, 1, 6)
   and a.l_month_id < substr(b.l_expiration_date, 1, 6)
   and a.l_month_id = 201612
 group by c.c_busi_scope_n
having round(sum(a.f_planned_eot) / 10000, 2) <> 0
 order by c.c_busi_scope_n;
 
--��������ҵ�����밴��Ŀ����
select c.c_proj_type_n,
	   round(sum(a.f_actual_eot) / 10000, 2)
  from tt_sr_tstrev_proj_m  a,
       dim_pb_project_basic b,
       dim_pb_project_biz   c,
       dim_pb_ie_status     d
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = C.L_PROJ_ID
   and a.l_revstatus_id = d.l_iestatus_id
   and d.c_iestatus_code = 'NEW'
   and a.l_month_id >= substr(b.l_effective_date, 1, 6)
   and a.l_month_id < substr(b.l_expiration_date, 1, 6)
   and a.l_month_id = 201612
 group by c.c_proj_type_n
having round(sum(a.f_planned_eot) / 10000, 2) <> 0
 order by c.c_proj_type_n;
 
--��������ҵ�����밴���ܷ���
select c.c_func_type_n,
       round(sum(a.f_actual_eot) / 10000, 2)
  from tt_sr_tstrev_proj_m  a,
       dim_pb_project_basic b,
       dim_pb_project_biz   c,
       dim_pb_ie_status     d
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = C.L_PROJ_ID
   and a.l_revstatus_id = d.l_iestatus_id
   and d.c_iestatus_code = 'NEW'
   and a.l_month_id >= substr(b.l_effective_date, 1, 6)
   and a.l_month_id < substr(b.l_expiration_date, 1, 6)
   and a.l_month_id = 201612
 group by c.c_func_type_n
having round(sum(a.f_planned_eot) / 10000, 2) <> 0
 order by c.c_func_type_n;

--������Ŀ������ģ������Ŀ����
select b.c_proj_type_n,
       count(*),
       sum(a.f_decrease_eot)/100000000
  from tt_sr_scale_proj_m    a,
       dim_pb_project_biz    b,
       dim_pb_object_status  c,
       tt_pb_object_status_m d,
       dim_pb_project_basic  e
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = d.l_object_id
   and d.c_object_type = 'XM'
   and c.l_objstatus_id = d.l_objstatus_id
   and c.l_expiry_ty_flag = 1
   and b.l_proj_id = e.l_proj_id
   and a.l_month_id = d.l_month_id
   and a.l_month_id = 201612
   and substr(e.l_effective_date,1,6) <= a.l_month_id
   and substr(e.l_expiration_date,1,6)>a.l_month_id
 group by b.c_proj_type_n
 order by b.c_proj_type_n;

--������Ŀ������ģ�������ܷ���
select b.c_func_type_n,
       count(*),
       sum(a.f_decrease_eot)/100000000
  from tt_sr_scale_proj_m    a,
       dim_pb_project_biz    b,
       dim_pb_object_status  c,
       tt_pb_object_status_m d,
       dim_pb_project_basic  e
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = d.l_object_id
   and d.c_object_type = 'XM'
   and c.l_objstatus_id = d.l_objstatus_id
   and c.l_expiry_ty_flag = 1
   and b.l_proj_id = e.l_proj_id
   and a.l_month_id = d.l_month_id
   and a.l_month_id = 201612
   and substr(e.l_effective_date,1,6) <= a.l_month_id
   and substr(e.l_expiration_date,1,6)>a.l_month_id
 group by b.c_func_type_n
 order by b.c_func_type_n; 
 
--������Ŀ������ģ
select b.c_special_type_n,
       count(*),
       sum(a.f_balance_eot)/100000000
  from tt_sr_scale_proj_m    a,
       dim_pb_project_biz    b,
       dim_pb_object_status  c,
       tt_pb_object_status_m d,
       dim_pb_project_basic  e
 where a.l_proj_id = b.l_proj_id
   and b.l_proj_id = d.l_object_id
   and d.c_object_type = 'XM'
   and c.l_objstatus_id = d.l_objstatus_id
   and c.l_exist_tm_flag = 1
   and b.l_proj_id = e.l_proj_id
   and a.l_month_id = d.l_month_id
   and a.l_month_id = 201612
   and substr(e.l_effective_date,1,6) <= a.l_month_id
   and substr(e.l_expiration_date,1,6)>a.l_month_id
   and nvl(b.c_special_type_n,'����) <> '����
 group by b.c_special_type_n
 order by b.c_special_type_n;

--����Ա���䶯����
select b.c_chgtype_name, sum(a.f_count_eot)
  from tt_hr_change_type_m a, dim_hr_change_type b
 where a.l_chgtype_id = b.l_chgtype_id
   and a.l_month_id = 201612
 group by b.c_chgtype_name
having sum(a.f_count_eot) <> 0;

--�Զ��屨��̶�����ִ�����
--��������
select a.c_item_code, a.c_item_name, c.f_value1 as ʵ��, c.f_value2 as Ԥ��
  from dim_op_report_item a, dim_op_report b, tt_op_report_m c
 where a.l_report_id = b.l_report_id
   and a.l_item_id = c.l_item_id
   and b.c_report_code = 'GDFYZXQK'
   and c.l_month_id = 201612;