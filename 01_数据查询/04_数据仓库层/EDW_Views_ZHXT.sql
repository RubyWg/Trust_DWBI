create or replace view v_pb_proj_info as
select pb1.l_proj_id,
       pb3.l_prod_id,
       pb1.c_proj_code          as "��Ŀ���(TCMP)",
       pb1.c_name_full          as "��Ŀ����(TCMP)",
       pb4.c_dept_name          as "ҵ����(TCMP)",
       pb2.c_manage_type_n      as "��������(TCMP)",
       pb2.c_proj_type_n        as "��Ŀ����(TCMP)",
       pb2.c_func_type_n        as "���ܷ���(BULU)",
       pb2.c_invest_indus_n     as "��Ŀʵ��Ͷ��(BULU)",
       to_date(pb1.l_setup_date, 'yyyymmdd')                as "��Ŀ��ʼ����(TCMP)",
       to_date(pb1.l_expiry_date, 'yyyymmdd')               as "��Ŀ��ֹ����(TCMP)",
       to_date(pb1.l_preexp_date, 'yyyymmdd')               as "��ĿԤ�Ƶ���(TCMP)",
       case when nvl(substr(pb1.l_expiry_date, 1, 6), 209912) > 201612 then  '����' else '����' end as "��Ŀ״̬(TCMP)",
       decode(pb2.l_pool_flag, 0, '��', 1, '��', null)  as "�Ƿ��ʽ��(BULU)",
       decode(pb2.c_special_type, 'A', '��', '��')      as "�ջݽ���(TCMP)",
       decode(pb2.l_pitch_flag, 0, '��', 1, '��', null) as "�Ƿ��ڳ���(TCMP)"
  from dim_pb_project_basic pb1,
       dim_pb_project_biz   pb2,
       dim_pb_product       pb3,
       dim_pb_department    pb4
 where pb1.l_proj_id = pb2.l_proj_id
   and pb1.l_setup_date <= 20161231
   and substr(pb1.l_Effective_Date, 1, 6) <= 201612
   and substr(pb1.l_expiration_date, 1, 6) > 201612
   and pb1.l_proj_id = pb3.l_proj_id
   and pb1.l_dept_id = pb4.l_dept_id;
      
create or replace view v_ic_cont_info as
select ic1.l_proj_id,
       ic1.l_prod_id,
       ic1.l_cont_id,
       ic1.c_cont_code                          as "��ͬ����(AM)",
       ic1.c_cont_name                          as "��ͬ����(AM)",
       to_date(ic1.l_begin_date, 'yyyymmdd')    as "��ͬ��ʼ��(AM)",
       to_date(ic1.l_expiry_date, 'yyyymmdd')   as "��ͬ��ֹ��(AM)",
       ic1.c_busi_type_n                        as "��ͬ����(AM)",
       ic1.c_invest_indus_n                     as "��ͬʵ��Ͷ��(BULU)",
       ic1.c_real_party                         as "ʵ�ʽ��׶���(BULU)",
       ic2.c_party_name                         as "��ͬ���׶���(AM)",
       ic1.c_invest_way_n                       as "Ͷ�ʷ�ʽ(BULU)",
       ic1.c_fduse_way_n                        as "�ʽ���;(BULU)",
       ic1.c_exit_way_n                         as "�˳���ʽ(BULU)",
       pb1.c_indus_name                         as "Ͷ����ҵ(BULU)",
       pb2.c_prov_name                          as "�ʽ�����ʡ��(BULU)",
       pb2.c_city_name                          as "�ʽ����ó���(BULU)",
       ic1.f_cost_rate                          as "���ʳɱ�(AM)",
       ic1.c_coop_partner                       as "�������(BULU)",
       decode(ic1.l_strategic_flag,1,'��','��') as "�Ƿ�ǩ����ս�Ժ���Э��(BULU)",
       null                                     as "��֤ȯͶ����ҵ(BULU)",
       null                                     as "��֤ȯͶ�ʷ�ʽ(BULU)",
       ic1.c_special_type_n                     as "��˾ս��ҵ��(BULU)",
       ic1.c_fiscal_revenue_n                   as "PPP��������(BULU)",
       decode(ic1.c_special_type, '7', ic1.c_subspecial_type_n, null) as "PPP��Ŀ����(BULU)",
       ic1.c_leading_party                                            as "PPP��Ŀ������(BULU)",
       ic1.c_repay_way_n                                              as "PPP��Ҫ������Դ(BULU)",
       decode(ic1.c_special_type, '4', ic1.c_subspecial_type_n, null) as "����������(BULU)",
       decode(ic1.c_special_type, '5', ic1.c_subspecial_type_n, null) as "��ɫ��������(BULU)",
       ic1.c_servicer                                                 as "�ջݽ��ڷ�����(BULU)",
       decode(ic1.c_special_type, '1', ic1.c_subspecial_type_n, null) as "�ջݽ���ҵ������(BULU)",
       ic1.c_gov_level_n                                              as "������������",
       pb2.c_special_type
  from dim_ic_contract ic1,dim_ic_counterparty ic2,dim_pb_industry pb1,dim_pb_area pb2,dim_pb_project_biz pb2
 where substr(ic1.l_Effective_Date, 1, 6) <= 201612
   and substr(ic1.l_expiration_date, 1, 6) > 201612
   and ic1.l_party_id = ic2.l_party_id(+)
   and ic1.l_invindus_id = pb1.l_indus_id(+)
   and ic1.l_fduse_area = pb2.l_area_id(+) --and ic1.l_proj_id = 642
   and ic1.l_proj_id = pb2.l_proj_id(+)
   --��ȡС���Ҵ���ĺ�ͬ
   and ((nvl(pb2.c_special_type, '0') = 'A' and  ic1.c_busi_type <> '1') 
       or (nvl(ic1.c_cont_type,'99') = '99')
       or (nvl(pb2.c_special_type, '0') <> 'A' )
   ); 
   
/*create or replace view v_ic_invest_cont_m as
select t.*,
       nvl��ratio_to_report(t.f_balance_agg)
                 OVER(partition by t.l_month_id, t.l_proj_id),
           1) f_invest_ratio
  from (select c.l_month_id, --�·�
               a.l_cont_id, --��ͬ
               b.l_prod_id, --��Ʒ
               b.l_proj_id, --��Ŀ
               sum(c.f_balance_agg) f_balance_agg, --Ͷ�����
               sum(decode(trunc(b.l_setup_date / 10000),
                          2016,
                          c.f_balance_agg,
                          c.f_invest_eot)) f_invest_eot,
               sum(c.f_return_agg) f_return_agg
          from dim_ic_contract a, dim_pb_product b, tt_ic_invest_cont_m c
         where c.l_cont_id = a.l_cont_id
           and a.l_prod_id = b.l_prod_id 
           and c.l_month_id = 201612 --and b.l_proj_id = 1715
           and substr(a.l_effective_date, 1, 6) <= c.l_month_id
           and substr(a.l_expiration_date, 1, 6) > c.l_month_id
         group by c.l_month_id, a.l_cont_id, b.l_prod_id, b.l_proj_id) t;*/
         
create or replace view v_ic_invest_cont_m as         
select ic1.l_month_id,
       ic2.l_cont_id,
       ic2.l_prod_id,
       ic2.l_proj_id,
       ic1.f_balance_agg as "Ͷ�ʺ�ͬ��ģ",
       decode(substr(pb1.l_setup_date, 1, 4),
              substr(ic1.l_month_id, 1, 4),
              ic1.f_balance_agg,
              ic1.f_invest_eot) as "����������ģ",
       ic1.f_return_agg as "�ۼƷ���",
       nvl��ratio_to_report(ic1.f_balance_agg) OVER(partition by ic1.l_month_id, ic2.l_proj_id),
       1) f_invest_ratio
  from tt_ic_invest_cont_m ic1, dim_ic_contract ic2, dim_pb_product pb1
 where ic1.l_month_id = 201612
   and ic1.l_cont_id = ic2.l_cont_id
   and ic2.l_prod_id = pb1.l_prod_id
   and substr(ic2.l_effective_date, 1, 6) <= ic1.l_month_id
   and substr(ic2.l_expiration_date, 1, 6) > ic1.l_month_id;

create or replace view v_to_balance_proj_m as
select to3.l_month_id, to1.l_book_id, to1.l_proj_id, to1.l_prod_id,
       to1.c_book_code as "���ױ��(FA)",
       sum(case when to2.c_subj_code_l1 = '4001' and to2.c_subj_code_l2 <> '400100' then to3.f_balance_agg else 0 end)                              as f_balance_scale,
       sum(case when to2.c_subj_code_l1 in ('1101', '1111', '1303', '1501','1503','1531','1541','1122','1511') then to3.f_balance_agg else 0 end) as f_balance_zc,
       sum(case when to2.c_subj_code_l1 in ('1303') then to3.f_balance_agg else 0 end)                                                            as f_balance_dk
  from dim_to_book to1, dim_to_subject to2, tt_to_accounting_subj_m to3
 where to1.l_book_id = to2.l_book_id
   and to1.l_book_id = to3.l_book_id
   and to2.l_subj_id = to3.l_subj_id
   and substr(to1.l_effective_date, 1, 6) <= to3.l_month_id
   and substr(to1.l_expiration_date, 1, 6) > to3.l_month_id
   and to2.l_effective_flag = 1
   and to3.l_month_id = 201612
 group by to3.l_month_id, to1.l_book_id,to1.l_proj_id,to1.l_prod_id,to1.c_book_code;
