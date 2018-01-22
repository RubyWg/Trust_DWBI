create or replace view v_zhxt_zjjjdb as
select h.c_book_code as "���ױ��(FA)",
       c.c_proj_code as "��Ŀ���(TCMP)",
       c.c_name_full as "��Ŀ����(TCMP)",
       i.c_dept_name as "ҵ����(TCMP)",
       d.c_manage_type_n as "��������(TCMP)",
       d.c_proj_type_n as "��Ŀ����(TCMP)",
       d.c_func_type_n as "���ܷ���(BULU)",
       d.c_invest_indus_n"��Ŀʵ��Ͷ��(BULU)",
       to_date(c.l_setup_date, 'yyyymmdd') as "��Ŀ��ʼ����(TCMP)",
       to_date(c.l_expiry_date, 'yyyymmdd') as "��Ŀ��ֹ����(TCMP)",
       to_date(c.l_preexp_date, 'yyyymmdd') as "��ĿԤ�Ƶ���(TCMP)",
       case when nvl(substr(c.l_expiry_date, 1, 6), 209912) > 201612 then  '����' else '����' end as "��Ŀ״̬(TCMP)",
       decode(d.l_pool_flag, 0, '��', 1, '��', null) as "�Ƿ��ʽ��(BULU)",
       decode(d.c_special_type, 'A', '��', '��') as "�ջݽ���(TCMP)",
       decode(d.l_pitch_flag, 0, '��', 1, '��', null) as "�Ƿ��ڳ���(TCMP)",
       a.c_cont_code as "��ͬ����(AM)",
       a.c_cont_name as "��ͬ����(AM)",
       to_date(a.l_begin_date, 'yyyymmdd') as "��ͬ��ʼ��(AM)",
       to_date(a.l_expiry_date, 'yyyymmdd') as "��ͬ��ֹ��(AM)",
       a.c_busi_type_n as "��ͬ����(AM)",
       a.c_invest_indus_n as "��ͬʵ��Ͷ��(BULU)",
       a.c_real_party as "ʵ�ʽ��׶���(BULU)",
       g.c_party_name as "��ͬ���׶���(AM)",
       a.c_invest_way_n as "Ͷ�ʷ�ʽ(BULU)",
       a.c_fduse_way_n as "�ʽ���;���˳���ʽ(BULU)",
       f.c_indus_name as "Ͷ����ҵ(BULU)",
       e.c_prov_name as "�ʽ�����ʡ��(BULU)",
       e.c_city_name as "�ʽ����ó���(BULU)",
       a.f_cost_rate as "���ʳɱ�(AM)",
       j.f_balance_agg as "Ͷ�ʺ�ͬ��ģ",
       j.f_invest_eot as "����������ģ",
       j.f_return_agg as "�ۼƷ���",
       --count(a.c_cont_code) over(partition by h.c_book_code),
       k.f_balance_zc,
       j.f_invest_ratio,
       k.f_balance_zc*j.f_invest_ratio "FAͶ�ʹ�ģ",
       null as "�Ƿ���FAһ��",
       a.c_coop_partner as "�������(BULU)",
       a.l_strategic_flag as "�Ƿ�ǩ����ս�Ժ���Э��(BULU)",
       null as "��֤ȯͶ����ҵ(BULU)",
       null as "��֤ȯͶ�ʷ�ʽ(BULU)",
       a.c_special_type_n as "��˾ս��ҵ��(BULU)",
       a.c_fiscal_revenue_n as "PPP��������(BULU)",
       decode(a.c_special_type, '7', a.c_subspecial_type_n, null) as "PPP��Ŀ����(BULU)",
       a.c_leading_party as "PPP��Ŀ������(BULU)",
       a.c_repay_way_n as "PPP��Ҫ������Դ(BULU)",
       decode(a.c_special_type, '4', a.c_subspecial_type_n, null) as "����������(BULU)",
       decode(a.c_special_type, '5', a.c_subspecial_type_n, null) as "��ɫ��������(BULU)",
       a.c_servicer as "�ջݽ��ڷ�����(BULU)",
       decode(a.c_special_type, '1', a.c_subspecial_type_n, null) as "�ջݽ���ҵ������(BULU)",
       a.c_gov_level_n as "������������"
  from dim_pb_project_basic c,
       dim_pb_project_biz   d,
       dim_ic_contract      a,
       dim_pb_product       b,
       dim_pb_area          e,
       dim_pb_industry      f,
       dim_ic_counterparty  g,
       dim_to_book          h,
       dim_pb_department    i,
       v_ic_invest_cont_m   j,
       v_to_balance_proj_m  k
 where c.l_proj_id = d.l_proj_id
   and c.l_proj_id = b.l_proj_id(+)
   and c.l_dept_id = i.l_dept_id(+)
   and c.l_proj_id = k.l_proj_id(+)
   and c.l_proj_id = a.l_proj_id(+)
   and a.l_fduse_area = e.l_area_id(+)
   and a.l_invindus_id = f.l_indus_id(+)
   and a.l_party_id = g.l_party_id(+)
   and a.l_prod_id = h.l_prod_id(+)
   and a.l_cont_id = j.L_CONT_ID(+)
   and ((nvl(d.c_special_type, '0') <> 'A' and  a.c_busi_type <> '1') or nvl(a.c_cont_type,'99') = '99') --��ȡС���Ҵ���ĺ�ͬ
   --and c.l_setup_date <= 20161231
   and j.L_MONTH_ID = 201612
   and k.l_month_id = 201612
   and c.c_proj_code = 'AVICTC2015X1517'
   and substr(c.l_Effective_Date, 1, 6) <= j.l_month_id
   and substr(c.l_expiration_date, 1, 6) > j.l_month_id;
