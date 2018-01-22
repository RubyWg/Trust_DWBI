
--��Ʒ����ֹ�����д�����ģ
with temp_scale as
 (select t.c_fundcode,
         sum(case
               when t.c_busiflag = '03' then
                t.f_tshares * -1
               else
                t.f_tshares
             end) as f_scale
    from ta_order t
   where t.c_busiflag in ('50', '02', '03')
   group by t.c_fundcode
  having sum(case
    when t.c_busiflag = '03' then
     t.f_tshares * -1
    else
     t.f_tshares
  end) <> 0)
select c.c_projcode as ��Ŀ����,
       c.c_fullname as ��Ŀ����,
       c.c_projstatus as ��Ŀ״̬,
       c.c_projphase as ��Ŀ�׶�,
       a.c_fundcode as ��Ʒ����,
       a.c_fundname as ��Ʒ����,
       a.d_issuedate as ��Ʒ��������,
       a.d_enddate as ��Ʒ��ֹ����,
       b.f_scale as ��ģ���
  from hstdc.ta_fundinfo a, hstdc.pm_projectinfo c, temp_scale b
 where a.c_projcode = c.c_projcode
   and nvl(a.d_enddate, to_date('20991231', 'yyyymmdd')) <=
       to_date('20151231', 'yyyymmdd')
   and a.c_fundcode = b.c_fundcode order by c.d_begdate;

--��ͬ����Ϊ��
select t.c_pactid, t.c_pactname, t.c_projcode, t.c_fundcode, t.l_pactprop
  from am_pact t
 where t.l_pactprop is null;

--���׶���������
select t.c_rivalid, t.c_rivalname, t.c_rivalkind
  from cm_rival t
 where t.c_rivalkind = '1'
   and length(t.c_rivalname) > 4;

--���׶���֤�������Ч
select t.c_rivalid, t.c_rivalname, t.c_idtype, t.c_idcard
  from cm_rival t
 where t.c_idtype < '1';

--Ͷ��ָ���Ʒ����
select *
  from am_order t
 where t.c_extype in ('101', '102', '105', '106')
   and t.c_fundcode = 'ZH0132';

--ta��Ʒ��ģ��ϸ
select *
  from ta_order t
 where t.c_fundcode in ('ZH03JC')
   and t.c_busiflag not in ('14', '15', '74')
 order by t.d_date;

--��¼���׶����޷������ʹ�
select t.c_projectcode,
       t.c_fundcode,
       t.c_contract_code,
       t.c_contract_name,
       t.c_rival_code
  from tamcontracts_bulu t
 where t.c_rival_code in
       (select distinct a.c_rival_code
          from tamcontracts_bulu a
         where not exists (select 1
                  from datadock.tam_counterparty b
                 where a.c_rival_code = b.c_party_name)
           and a.c_rival_code is not null);
           
--���Ѽƻ�ʵ����֧����״̬δ��ɵļ�¼
select s.d_delivery          as ʵ��֧������,
       s.f_dlvamount     as ʵ��֧�����,
       t.l_serial_no     as �������к�,
       t.vc_product_id   as ��Ʒ����,
       r.c_fundname as ��Ʒ����,
       t.c_ext_flag      as ҵ�����,
       t.l_begin_date    as ��Ϣ��,
       t.l_End_Date      as ��Ϣ��,
       t.l_plan_date     as �ƻ�����,
       t.en_plan_balance as �ƻ����
  from bulu_amfareplan t, hstdc.am_order s,hstdc.ta_fundinfo r 
 where t.vc_product_id = s.c_fundcode --��Ʒ����һ��
   and t.c_ext_flag = s.c_extype --��չ����һ��
   and to_date(t.l_plan_date, 'yyyymmdd') = s.d_delivery --֧������һ��
   and t.en_plan_balance = s.f_dlvamount --֧�����һ��
   and t.l_end_date <= 20160930
   and t.l_occur_date = 0 --״̬δ֧��
   and s.c_fundcode = r.c_fundcode
   --and s.d_delivery is not null
   and t.c_ext_flag in ('101','102','105','106')
   order by s.d_delivery desc
   ;
   
 select * from bulu_amfareplan t where t.vc_product_id = 'ZH01GO' and t.l_serial_no = 23722;

 select * from hstdc.am_order t where t.c_fundcode = 'ZH01GO' and t.d_delivery = to_date('20160920','yyyymmdd');
 
 select c.l_astype ��������,c.c_projcode ��Ŀ����,c.c_subprojcode ����Ŀ����, a.l_fundid ���ױ���,a.vc_code ��Ʒ����,a.vc_name ��Ʒ����,a.l_jjtzlx ��ƷͶ������,a.vc_xmbm ��Ŀ����
  from tfundinfo_fa a, hstdc.fa_fundinfo c
 where a.l_fundid = c.c_fundid(+)
   and not exists
 (select 1 from hstdc.ta_fundinfo b where a.vc_code = b.c_fundcode)
   and a.vc_code <> '1'
   and c.c_projcode is not null;
   

select max(length(t.c_subcode)),min(length(t.c_subcode)) from fa_subject t where t.l_level = 2;

select distinct t.c_subcode from fa_subject t  where t.l_level = 2 and length(t.c_subcode)>6 and t.l_leaf = 0;

select distinct t.c_subcode from fa_subject t  where t.l_level = 5 and length(t.c_subcode)>12 and t.l_leaf = 0;

select * from fa_subject t where t.c_subcode = '11320102' and t.l_level = 3
and exists(select 1 from fa_vouchers s where t.c_fundid = s.c_fundid and t.c_subcode = s.c_subcode);
select * from fa_subject t where t.c_fsubcode = '11320102' and t.c_fundid = '100754';









