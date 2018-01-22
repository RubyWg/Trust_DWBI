create or replace view v_ic_cont_info as
with temp_special_type as
 (select t.l_cont_id,
         listagg(t.c_props_type_n, ',') within group(order by t.l_cont_id, t.c_props_type) as c_special_type_n
    from dim_ic_contract_derive t
   where t.l_effective_flag = 1
   group by t.l_cont_id)
select ic1.l_proj_id,
       ic1.l_prod_id,
       ic1.l_cont_id,
       ic1.c_cont_code                          as "��ͬ����(AM)",
       ic1.c_cont_name                          as "��ͬ����(AM)",
       to_date(ic1.l_begin_date, 'yyyymmdd')    as "��ͬ��ʼ��(AM)",
       to_date(ic1.l_expiry_date, 'yyyymmdd')   as "��ͬ��ֹ��(AM)",
       decode(pb2.l_pitch_flag,1,'����Ͷ��',ic1.c_busi_type_n)    as "��ͬ����(AM)",
       ic1.c_invest_indus_n                     as "��ͬʵ��Ͷ��(BULU)",
       ic1.c_real_party                         as "ʵ�ʽ��׶���(BULU)",
       ic2.c_party_name                         as "��ͬ���׶���(AM)",
       ic1.c_invest_way_n                       as "Ͷ�ʷ�ʽ(BULU)",
       ic1.c_fduse_way_n                        as "�ʽ���;(BULU)",
       ic1.c_exit_way_n                         as "Ԥ���˳���ʽ(BULU)",
       pb1.c_indus_name                         as "Ͷ����ҵ(BULU)",
       pb2.c_prov_name                          as "�ʽ�����ʡ��(BULU)",
       pb2.c_city_name                          as "�ʽ����ó���(BULU)",
       ic1.f_cost_rate                          as "���ʳɱ�(AM)",
       ic1.c_coop_partner                       as "�������(BULU)",
       decode(ic1.l_strategic_flag,1,'��','��') as "�Ƿ�ǩ����ս�Ժ���Э��(BULU)",
       pb1.c_indus_name                         as "��֤ȯͶ����ҵ(BULU)",
       null                                     as "��֤ȯͶ�ʷ�ʽ(BULU)",
       temp1.c_special_type_n                     as "��˾ս��ҵ��(BULU)",
       ic1.c_fiscal_revenue_n                   as "PPP��������(BULU)",
       decode(ic1.c_special_type, '7', ic1.c_subspecial_type_n, null) as "PPP��Ŀ����(BULU)",
       ic1.c_leading_party                                            as "PPP��Ŀ������(BULU)",
       ic1.c_repay_way_n                                              as "PPP��Ҫ������Դ(BULU)",
       decode(ic1.c_special_type, '4', ic1.c_subspecial_type_n, null) as "����������(BULU)",
       decode(ic1.c_special_type, '5', ic1.c_subspecial_type_n, null) as "��ɫ��������(BULU)",
       ic1.c_servicer                                                 as "�ջݽ��ڷ�����(BULU)",
       decode(ic1.c_special_type, '1', ic1.c_subspecial_type_n, null) as "�ջݽ���ҵ������(BULU)",
       ic1.c_gov_level_n                                              as "������������(BULU)",
       decode(ic1.l_xzhz_flag,1,'��','��')                            as "�Ƿ���������(BULU)",
       decode(ic1.l_invown_flag,1,'��','��')                          as "�Ƿ�Ͷ�ʹ�˾������Ŀ(BULU)",
       ic1.c_func_type_n                                              as "��ͬ���ܷ���(BULU)",
       ic1.c_manage_type_n                                            as "��ͬ����ʽ(BULU)",
       pb2.c_special_type
  from dim_ic_contract ic1,dim_ic_counterparty ic2,dim_pb_industry pb1,dim_pb_area pb2,dim_pb_project_biz pb2,temp_special_type temp1
 where substr(ic1.l_Effective_Date, 1, 6) <= 201707
   and substr(ic1.l_expiration_date, 1, 6) > 201707
   and ic1.l_party_id = ic2.l_party_id(+)
   and ic1.l_invindus_id = pb1.l_indus_id(+)
   and ic1.l_fduse_area = pb2.l_area_id(+)
   and ic1.l_proj_id = pb2.l_proj_id(+)
   and ic1.l_cont_id = temp1.l_cont_id(+)
   --��ȡС���Ҵ���ĺ�ͬ
   and ((nvl(pb2.c_special_type, '0') = 'A' and  ic1.c_busi_type <> '1')
       or (nvl(ic1.c_cont_type,'XN') = 'XN')
       or (nvl(pb2.c_special_type, '0') <> 'A' )
   );
