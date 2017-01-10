--��ֹ��2016��9�µ���Ŀ���б���
--�����ڳ�������
select e.c_projcode,
       e.c_fullname,
       b.c_itemname,
       substr(a.c_subcode, 1, 4),
       sum(a.f_credit)
  from fa_vouchers_innate a, --����ƾ֤��
       fa_asitem_innate   b, --���Ѹ�����Ϣ
       fa_asclass_innate  c, --���Ѹ������
       fa_bd_jobbasfil    d, --������Ŀ����ӳ��
       pm_projectinfo     e --��Ŀ��Ϣ��
 where a.c_combid = b.c_combid
   and b.c_classid = c.c_classid
   and c.c_classno = 'J04Ass'
   and b.c_itemno = d.jobcode
   and a.l_year = 2016
   and a.l_month <= 9
   and d.def1 = e.c_projcode
   and a.l_state <> 32
   and substr(a.c_subcode, 1, 4) in ('6021', '6051') --6021���б���,6051���вƹ˷�
 group by e.c_projcode,
          e.c_projname,
          b.c_itemname,
          substr(a.c_subcode, 1, 4);

--��ѯָ����Ŀ�´��ڵ��ӿ�Ŀ����
select COUNT(*) AS F_OUTPUT
  from (SELECT t.c_subcode
          FROM (select fa_subject.c_fundid as c_ffundid, fa_subject.*
                  from fa_subject
                 where c_fundid = '100802') t
         where connect_by_isleaf = 1
         START WITH t.c_fsubcode = '11010131'
        CONNECT BY t.c_fsubcode = PRIOR t.c_subcode
               and t.c_ffundid = prior t.c_fundid) t1,
       (select distinct fa_vouchers.c_subcode
          from fa_vouchers
         where fa_vouchers.c_fundid = '100802') s
 where t1.c_subcode = s.c_subcode;	  

--ָ����ĿFA����������ϸ
SELECT FA_VOUCHERS_INNATE.C_JOURID,
       FA_VOUCHERS_INNATE.C_FUNDID,
       FA_VOUCHERS_INNATE.D_BUSI,
       FA_VOUCHERS_INNATE.C_DIGEST,
       FA_VOUCHERS_INNATE.C_SUBCODE,
       FA_VOUCHERS_INNATE.C_SUBNAME,
       FA_VOUCHERS_INNATE.L_BALDIR,
       FA_VOUCHERS_INNATE.F_DEBIT,
       FA_VOUCHERS_INNATE.F_CREDIT,
       FA_VOUCHERS_INNATE.C_CYKIND,
       FA_VOUCHERS_INNATE.F_EXCH,
       FA_VOUCHERS_INNATE.F_FOREIGN,
       FA_VOUCHERS_INNATE.L_STATE,
       FA_VOUCHERS_INNATE.L_YEAR,
       FA_VOUCHERS_INNATE.L_MONTH,
       FA_ASITEM_INNATE.C_ITEMNO,
       FA_ASCLASS_INNATE.C_CLASSNO
  FROM FA_VOUCHERS_INNATE, FA_ASITEM_INNATE, FA_ASCLASS_INNATE
 WHERE FA_VOUCHERS_INNATE.C_FUNDID = '01-0001'
   and FA_VOUCHERS_INNATE.L_STATE < 32
   AND FA_VOUCHERS_INNATE.C_COMBID = FA_ASITEM_INNATE.C_COMBID(+)
   and FA_ASITEM_INNATE.C_CLASSID = FA_ASCLASS_INNATE.C_CLASSID(+)
   and FA_ASITEM_INNATE.C_ITEMNO = 'G39900';

--���Ѳ����޷�������tcmp��Ŀ
--ʹ�ó�������
select distinct b.c_itemno
  from fa_vouchers_innate a,
       fa_asitem_innate   b,
       fa_asclass_innate  c,
       fa_bd_jobbasfil    d
 where a.c_combid = b.c_combid
   and b.c_classid = c.c_classid
   and c.c_classno = 'J04Ass'
   and b.c_itemno = d.jobcode
   and a.l_year >= 2015
   and substr(a.c_subcode, 1, 4) in ('6021', '6051')
   and not exists
 (select 1 from pm_projectinfo e where d.def1 = e.c_projcode);