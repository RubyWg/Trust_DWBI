--ͬһ���β�ͬ������
select distinct tt.��Ʒ����,tt.��Ʒ���� from (
select f.c_projectcode as ��Ŀ����,
       d.c_fundcode as ��Ʒ����,
       f.c_fundname as ��Ʒ����,
       d.d_cdate as ȷ������,
       d.l_serialno as ��ͬ�ڲ����к�,
       d.c_trustcontractid as ��ͬ�ⲿ���к�,
       d.d_contractsigndate as ��ͬǩԼ����,
       d.d_contractenddate as ��ͬ��������,
       d.f_shares as ���깺���,
       d.c_feqj as �ݶ�����,
       d.c_custname as �ͻ�����,
       decode(d.c_custtype, '1', '��Ȼ��', '����') as �ͻ�����,
       decode(nvl(e.f_profit, 0),0,d.f_profit,e.f_profit) as ������,
       count(distinct nvl(e.f_profit, 0)) over(partition by d.c_fundcode, d.d_cdate) as �����ʲ�������
  from (select a.c_fundcode,
               a.d_cdate,
               b.l_serialno,
               b.c_trustcontractid,
               b.d_contractsigndate,
               b.d_contractenddate,
               a.f_shares,
               case
                 when a.f_shares < 3000000 then
                  '300������'
                 when a.f_shares >= 3000000 and a.f_shares < 10000000 then
                  '300��1000������'
                 else
                  '1000������'
               end as c_feqj,
               b.f_profit,
               b.c_profitclass,
               c.c_custname,
               c.c_custtype
          from (select a1.c_fundcode,
                       a1.d_cdate,
                       a1.l_contractserialno,
                       sum(a1.f_confirmshares) as f_shares
                  from tconfirm a1
                 where a1.c_businflag in ('50', '02')
                   and to_char(a1.d_cdate, 'yyyy') >= '2016'
                 group by a1.c_fundcode, a1.d_cdate, a1.l_contractserialno) a,
               ttrustcontractdetails b,
               ttrustclientinfo c
         where a.l_contractserialno = b.l_serialno
           and b.c_clientinfoid = c.c_clientinfoid
           and c.c_custtype = '1') d,
       ttrustfundprofit e,
       tfundinfo f
 where d.c_fundcode = e.c_fundcode(+)
   and d.c_profitclass = e.c_profitclass(+)
   and d.c_fundcode = f.c_fundcode(+)
 order by d.c_fundcode, d.d_cdate
 ) tt where tt.�����ʲ������� > 1
 ;

--��ͬ��������Ϣ
select t1.c_fundcode, t.c_profitclass, t.f_profit,t2.f_profit,t.l_parentserialno
  from ttrustcontractdetails t, ttrustcontracts t1, ttrustfundprofit t2
 where t.l_contractserialno = t1.l_serialno
   and t.c_profitclass = t2.c_profitclass
   and t1.c_fundcode = t2.c_fundcode
   and t.l_serialno in (434563);

--��ͬ������Ϣ
select * from tconfirm t where t.l_contractserialno = 434563 ;

--��ͬ���������Ϣ
select t.f_curbenefitcapital,t.f_repaycapital,t.f_profit from tprofitdealcurrentdetails t where t.l_contractserialno = 434563;
