--ͬһ���εĲ�ͬ������
select distinct tt.��Ʒ����,tt.��Ʒ���� from (
select d.c_projectcode as ��Ŀ����,
       a.c_fundcode as ��Ʒ����,
       d.c_fundname as ��Ʒ����,
       a.d_cdate as ȷ������,
       b.l_serialno as ��ͬ�ڲ����к�,
       b.c_trustcontractid as ��ͬ�ⲿ���к�,
       b.d_contractsigndate as ��ͬǩԼ����,
       b.d_contractenddate as ��ͬ��������,
       a.f_confirmshares as ���깺�ݶ�,
       c.c_custname as �ͻ�����,
       decode(c.c_custtype, '1', '��Ȼ��', '����') as �ͻ�����,
       count(distinct
             nvl(b.d_contractenddate, to_date('20991231', 'yyyymmdd'))) over(partition by a.c_fundcode, a.d_cdate) as ��ͬ�����ղ�������
  from tconfirm a, ttrustcontractdetails b, ttrustclientinfo c, tfundinfo d
 where a.l_contractserialno = b.l_serialno
   and b.c_clientinfoid = c.c_clientinfoid
   and c.c_custtype = '1'
   and a.c_businflag in ('50', '02')
   and to_char(a.d_cdate, 'yyyy') >= '2016'
   and a.c_fundcode = d.c_fundcode
 order by a.c_fundcode, a.d_cdate ) tt where tt.��ͬ�����ղ������� > 1;
