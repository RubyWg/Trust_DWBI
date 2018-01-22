create or replace view v2 as
with v_pb_proj_info1 as (
select pb1.l_proj_id,
       pb3.l_prod_id,
       to_date(pb3.l_setup_date,'yyyymmdd')        as "��Ʒ������"��
       pb1.c_proj_code          as "��Ŀ���",
       pb1.c_name_full          as "��Ŀ����",
       pb4.c_dept_name          as "ҵ����",
       pb2.c_manage_type_n      as "��Ŀ��������",
       pb2.c_proj_type_n        as "��Ŀ����",
       pb3.c_func_type_n        as "��Ʒ���ܷ���",
       pb3.c_invest_indus_n     as "��Ʒʵ��Ͷ��",
       to_date(pb1.l_setup_date, 'yyyymmdd')                as "��Ŀ��ʼ����",
       to_date(pb1.l_expiry_date, 'yyyymmdd')               as "��Ŀ��ֹ����",
       to_date(pb1.l_preexp_date, 'yyyymmdd')               as "��ĿԤ�Ƶ���",
       case when nvl(substr(pb1.l_expiry_date, 1, 6), 209912) > to_char(To_Date('30-09-2017', 'dd-mm-yyyy'),'yyyymm') then  '����' else '����' end as "��Ŀ״̬",
       decode(pb2.l_pool_flag, 0, '��', 1, '��', null)  as "�Ƿ��ʽ��",
       decode(pb2.c_special_type, 'A', '��', '��')      as "�ջݽ���",
       decode(pb2.l_pitch_flag, 0, '��', 1, '��', null) as "�Ƿ��ڳ���",
       decode(pb2.l_openend_flag, 0, '��', 1, '��', null) as "�Ƿ񿪷�ʽ"
  from dim_pb_project_basic pb1,
       dim_pb_project_biz   pb2,
       dim_pb_product       pb3,
       dim_pb_department    pb4
 where pb1.l_proj_id = pb2.l_proj_id
   and pb1.l_setup_date <= to_char(To_Date('30-09-2017', 'dd-mm-yyyy'),'yyyymmdd')
   and substr(pb1.l_Effective_Date, 1, 6) <= to_char(To_Date('30-09-2017', 'dd-mm-yyyy'),'yyyymm')
   and substr(pb1.l_expiration_date, 1, 6) > to_char(To_Date('30-09-2017', 'dd-mm-yyyy'),'yyyymm')
   and pb1.l_proj_id = pb3.l_proj_id
   and pb1.l_dept_id = pb4.l_dept_id),

v_to_balance_proj_m1 as (
select tt."L_MONTH_ID",tt."C_BOOK_CODE",tt."L_BOOK_ID",tt."L_PROJ_ID",tt."L_PROD_ID",tt."���ױ��",tt."F_BALANCE_SCALE",tt."F_BALANCE_ZC",tt."F_BALANCE_DK",sum(tt.f_balance_zc)over(partition by tt.l_proj_id)  as f_proj_balance_zc from (
select to3.l_month_id, to1.c_book_code, to1.l_book_id, to1.l_proj_id, to1.l_prod_id,
       to1.c_book_code as "���ױ��",
       sum(case when to2.c_subj_code_l1 = '4001' and to2.c_subj_code_l2 <> '400100' then to3.f_balance_agg else 0 end)                              as f_balance_scale,
       sum(case when to2.c_subj_code_l1 in ('1101', '1111', '1303', '1501','1503','1531','1541','1122','1511') then to3.f_balance_agg else 0 end) as f_balance_zc,
       sum(case when to2.c_subj_code_l1 in ('1303') then to3.f_balance_agg else 0 end)                                                            as f_balance_dk
  from dim_to_book to1, dim_to_subject to2, tt_to_accounting_subj_m to3
 where to1.l_book_id = to2.l_book_id
   and to1.l_book_id = to3.l_book_id
   and to2.l_subj_id = to3.l_subj_id
   and substr(to2.l_effective_date, 1, 6) <= to3.l_month_id
   and substr(to2.l_expiration_date, 1, 6) > to3.l_month_id
   --and to2.l_effective_flag = 1
   and to3.l_month_id = to_char(To_Date('30-09-2017', 'dd-mm-yyyy'),'yyyymm')
 group by to3.l_month_id, to1.c_book_code,to1.l_book_id,to1.l_proj_id,to1.l_prod_id,to1.c_book_code) tt),

temp_special_type as (
select t.l_cont_id,
         listagg(t.c_props_type_n, ',') within group(order by t.l_cont_id, t.c_props_type) as c_special_type_n
    from dim_ic_contract_derive t
   where t.l_effective_flag = 1
   group by t.l_cont_id),
v_ic_cont_info1 as (
select ic1.l_proj_id,
       ic1.l_prod_id,
       ic1.l_cont_id,
       ic1.c_cont_code                          as "��ͬ����",
       ic1.c_cont_name                          as "��ͬ����",
       to_date(ic1.l_begin_date, 'yyyymmdd')    as "��ͬ��ʼ��",
       to_date(ic1.l_expiry_date, 'yyyymmdd')   as "��ͬ��ֹ��",
       decode(pb2.l_pitch_flag,1,'����Ͷ��',ic1.c_busi_type_n)    as "��ͬ����",
       (case when nvl(pb2.c_special_type, '0') = 'A' and nvl(ic1.c_cont_type,'XN') = 'XN' and ic1.c_invest_indus_n is null then '����'
        else ic1.c_invest_indus_n end) as "��ͬʵ��Ͷ��",
       ic1.c_real_party                         as "ʵ�ʽ��׶���",
       ic2.c_party_name                         as "��ͬ���׶���",
       ic1.c_invest_way_n                       as "Ͷ�ʷ�ʽ",
       ic1.c_fduse_way_n                        as "�ʽ���;",
       ic1.c_exit_way_n                         as "Ԥ���˳���ʽ",
       pb1.c_indus_name                         as "Ͷ����ҵ",
       pb2.c_prov_name                          as "�ʽ�����ʡ��",
       pb2.c_city_name                          as "�ʽ����ó���",
       ic1.f_cost_rate                          as "���ʳɱ�",
       ic1.c_coop_partner                       as "�������",
       decode(ic1.l_strategic_flag,1,'��','��') as "�Ƿ�ǩ����ս�Ժ���Э��",
       pb1.c_indus_name                         as "��֤ȯͶ����ҵ",
       null                                     as "��֤ȯͶ�ʷ�ʽ",
       temp1.c_special_type_n                     as "��˾ս��ҵ��",
       ic1.c_fiscal_revenue_n                   as "PPP��������",
       decode(ic1.c_special_type, '7', ic1.c_subspecial_type_n, null) as "PPP��Ŀ����",
       ic1.c_leading_party                                            as "PPP��Ŀ������",
       ic1.c_repay_way_n                                              as "PPP��Ҫ������Դ",
       decode(ic1.c_special_type, '4', ic1.c_subspecial_type_n, null) as "����������",
       decode(ic1.c_special_type, '5', ic1.c_subspecial_type_n, null) as "��ɫ��������",
       ic1.c_servicer                                                 as "�ջݽ��ڷ�����",
       decode(ic1.c_special_type, '1', ic1.c_subspecial_type_n, null) as "�ջݽ���ҵ������",
       ic1.c_gov_level_n                                              as "������������",
       decode(ic1.l_xzhz_flag,1,'��','��')                            as "�Ƿ���������",
       decode(ic1.l_invown_flag,1,'��','��')                          as "�Ƿ�Ͷ�ʹ�˾������Ŀ",
       ic1.c_func_type_n                                              as "��ͬ���ܷ���",
       ic1.c_manage_type_n                                            as "��ͬ����ʽ",
       ic1.c_manage_type,
       pb2.c_special_type
  from dim_ic_contract ic1,dim_ic_counterparty ic2,dim_pb_industry pb1,dim_pb_area pb2,dim_pb_project_biz pb2,temp_special_type temp1
 where substr(ic1.l_Effective_Date, 1, 6) <= to_char(To_Date('30-09-2017', 'dd-mm-yyyy'),'yyyymm')
   and substr(ic1.l_expiration_date, 1, 6) > to_char(To_Date('30-09-2017', 'dd-mm-yyyy'),'yyyymm')
   and ic1.l_party_id = ic2.l_party_id(+)
   and ic1.l_invindus_id = pb1.l_indus_id(+)
   and ic1.l_fduse_area = pb2.l_area_id(+)
   and ic1.l_proj_id = pb2.l_proj_id(+)
   and ic1.l_cont_id = temp1.l_cont_id(+)
   and substr(ic1.l_begin_date, 1, 6) <= to_char(To_Date('30-09-2017', 'dd-mm-yyyy'),'yyyymm')
   --��ȡС���Ҵ���ĺ�ͬ
   and ((nvl(pb2.c_special_type, '0') = 'A' and  ic1.c_busi_type <> '1')
       or (nvl(ic1.c_cont_type,'XN') = 'XN')
       or (nvl(pb2.c_special_type, '0') <> 'A' )
   )),

v_ic_invest_cont_m1 as (
select ic1.l_month_id,
       ic2.l_cont_id,
       ic2.l_prod_id,
       ic2.l_proj_id,
       ic1.f_balance_agg,
       ic1.f_invest_eot as f_invest_eot,
       ic1.f_return_agg,
       nvl��ratio_to_report(ic1.f_balance_agg) OVER(partition by ic1.l_month_id, ic2.l_proj_id),
       1/count(ic1.f_balance_agg)over(partition by ic1.l_month_id, ic2.l_proj_id)) f_invest_ratio
  from (select t.l_month_id,
               t.l_cont_id,
               sum(t.f_balance_agg) as f_balance_agg,
               sum(t.f_invest_eot) as f_invest_eot,
               sum(t.f_return_agg) as f_return_agg
          from tt_ic_invest_cont_m t
         group by t.l_month_id, t.l_cont_id) ic1,
       dim_ic_contract ic2,
       dim_pb_product pb1
 where ic1.l_month_id = to_char(To_Date('30-09-2017', 'dd-mm-yyyy'),'yyyymm')
   and ic1.l_cont_id = ic2.l_cont_id
   and ic2.l_prod_id = pb1.l_prod_id
   and substr(ic2.l_effective_date, 1, 6) <= ic1.l_month_id
   and substr(ic2.l_expiration_date, 1, 6) > ic1.l_month_id)
select x."���ױ��",x."��Ŀ���",x."��Ŀ����",x."ҵ����",x."��Ŀ��������",x."��Ŀ����",x."��Ʒ���ܷ���",x."��Ʒʵ��Ͷ��",x."��Ŀ��ʼ����",x."��Ŀ��ֹ����",x."��ĿԤ�Ƶ���",x."��Ŀ״̬",x."�Ƿ��ʽ��",x."�ջݽ���",x."�Ƿ��ڳ���",x."��Ʒ������",x."��ͬ����",x."��ͬ����",x."��ͬ��ʼ��",x."��ͬ��ֹ��",x."��ͬ����",x."��ͬʵ��Ͷ��",x."ʵ�ʽ��׶���",x."��ͬ���׶���",x."�ʽ���;",x."�ʽ�����ʡ��",x."�ʽ����ó���",x."���ʳɱ�",x."Ͷ�ʺ�ͬ��ģ",x."����������ģ",x."�ۼƷ���",x."FAͶ�ʹ�ģ",x."�Ƿ���FAһ��",x."Ԥ���˳���ʽ",x."�������",x."Ͷ�ʷ�ʽ",x."��֤ȯͶ����ҵ",x."�Ƿ�ǩ����ս�Ժ���Э��",x."��˾ս��ҵ��",x."PPP��������",x."PPP��Ŀ����",x."PPP��Ŀ������",x."PPP��Ҫ������Դ",x."����������",x."��ɫ��������",x."�ջݽ��ڷ�����",x."�ջݽ���ҵ������",x."�Ƿ���������",x."������������",x."�Ƿ�Ͷ�ʹ�˾������Ŀ",x."��ͬ���ܷ���",x."��ͬ����ʽ" from (
select v4.c_book_code as "���ױ��",
       v1."��Ŀ���",
       v1."��Ŀ����",
       v1."ҵ����",
       v1."��Ŀ��������",
       v1."��Ŀ����",
       v1."��Ʒ���ܷ���",
       v1."��Ʒʵ��Ͷ��",
       v1."��Ŀ��ʼ����",
       v1."��Ŀ��ֹ����",
       v1."��ĿԤ�Ƶ���",
       v1."��Ŀ״̬",
       v1."�Ƿ��ʽ��",
       v1."�ջݽ���",
       v1."�Ƿ��ڳ���",
       v1."��Ʒ������",
       v2."��ͬ����",
       v2."��ͬ����",
       v2."��ͬ��ʼ��",
       v2."��ͬ��ֹ��",
       v2."��ͬ����",
       v2."��ͬʵ��Ͷ��",
       v2."ʵ�ʽ��׶���",
       v2."��ͬ���׶���",
       v2."�ʽ���;",
       v2."�ʽ�����ʡ��",
       v2."�ʽ����ó���",
       v2."���ʳɱ�",
       v3.f_balance_agg as "Ͷ�ʺ�ͬ��ģ",
       v3.f_invest_eot as "����������ģ",
       v3.f_return_agg as "�ۼƷ���",
       decode(v2.l_cont_id,null,v4.f_balance_zc,v3.f_invest_ratio*v4.f_proj_balance_zc) as "FAͶ�ʹ�ģ",
       decode(sum(nvl(v3.f_balance_agg,0))over(partition by v1.l_proj_id),v4.f_proj_balance_zc,'��','��') "�Ƿ���FAһ��",
       v2."Ԥ���˳���ʽ",
       v2."�������",
       v2."Ͷ�ʷ�ʽ",
       v2."��֤ȯͶ����ҵ",
       v2."�Ƿ�ǩ����ս�Ժ���Э��",
       v2."��˾ս��ҵ��",
       v2."PPP��������",
       v2."PPP��Ŀ����",
       v2."PPP��Ŀ������",
       v2."PPP��Ҫ������Դ",
       v2."����������",
       v2."��ɫ��������",
       v2."�ջݽ��ڷ�����",
       v2."�ջݽ���ҵ������",
       v2."�Ƿ���������",
       v2."������������",
       v2."�Ƿ�Ͷ�ʹ�˾������Ŀ",
       v2."��ͬ���ܷ���",
       v2."��ͬ����ʽ"
  from v_pb_proj_info1 v1,v_to_balance_proj_m1 v4, v_ic_cont_info1 v2,v_ic_invest_cont_m1 v3
 where v1.l_proj_id = v4.l_proj_id(+)
   and v1.l_prod_id = v4.l_prod_id(+)
   and v1.l_proj_id = v2.l_proj_id(+)
   and v1.l_prod_id = v2.l_prod_id(+)
   and v2.l_cont_id = v3.l_cont_id(+)
   ) x where (x."���ױ��" is not null or x."��ͬ����" is not null);
