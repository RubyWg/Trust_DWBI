--��Ʒ16���Ժ�����İ�����Ȼ�˵�
--16���Ժ�����ҵ���
with temp_wtr as
 (select t1.c_fundcode, t2.l_serialno, t3.c_custno, t3.c_custname
    from ttrustcontracts t1, ttrustcontractdetails t2, ttrustclientinfo t3
   where t1.l_serialno = t2.l_contractserialno
     and t2.c_clientinfoid = t3.c_clientinfoid
     and t3.c_custtype = '1')
select c.c_projectcode      as ��Ŀ����,
       c.c_projectname      as ��Ŀ����,
       c.d_projectsetupdate as ��Ŀ��������,
       c.d_enddate          as ��Ŀ��������,
       a.c_fundcode         as ��Ʒ����,
       a.c_fundname         as ��Ʒ����,
       a.d_setupdate        as ��Ʒ��������,
       a.d_contractenddate  as ��Ʒ��������,
       a.d_extenddate       as ��Ʒ��������
  from tfundinfo a, ttrustprojects c
 where a.c_projectcode = c.c_projectcode
      --and to_char(a.d_setupdate, 'yyyy') >= '2016'
   and exists (select 1 from temp_wtr b where a.c_fundcode = b.c_fundcode)
   and exists (select 1
          from tconfirm d
         where a.c_fundcode = d.c_fundcode
           and to_char(d.d_cdate, 'yyyy') >= '2016' and d.c_businflag in ('50','02'));

--16���Ժ�ǩԼ�ĺ�ͬ
with temp_wtr as
 (select t1.c_fundcode, t2.l_serialno, t3.c_custno, t3.c_custname
    from ttrustcontracts t1, ttrustcontractdetails t2, ttrustclientinfo t3
   where t1.l_serialno = t2.l_contractserialno
     and t2.c_clientinfoid = t3.c_clientinfoid
     and t3.c_custtype = '1')
select c.c_projectcode      as ��Ŀ����,
       c.c_projectname      as ��Ŀ����,
       c.d_projectsetupdate as ��Ŀ��������,
       c.d_enddate          as ��Ŀ��������,
       a.c_fundcode         as ��Ʒ����,
       a.c_fundname         as ��Ʒ����,
       a.d_setupdate        as ��Ʒ��������,
       a.d_contractenddate  as ��Ʒ��������,
       a.d_extenddate       as ��Ʒ��������
  from tfundinfo a, ttrustprojects c
 where a.c_projectcode = c.c_projectcode
      --and to_char(a.d_setupdate, 'yyyy') >= '2016'
   and exists (select 1 from temp_wtr b where a.c_fundcode = b.c_fundcode)
   and exists (select 1
          from ttrustcontractdetails d,ttrustcontracts e
         where d.l_contractserialno = e.l_serialno
         and e.c_fundcode = a.c_fundcode
           and to_char(d.d_contractsigndate, 'yyyy') >= '2016');
