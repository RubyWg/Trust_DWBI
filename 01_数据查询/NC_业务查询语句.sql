--NC�ֵ��
--����PK_DEFDOC��ѯ
select *
  from BD_DEFDOC t
 where t.pk_defdoc = '0001Q010000000004W5L';

--��˾��Ϣ
select t.pk_corp as ��˾����,
       t.unitcode as ��˾����,
       t.unitname as ��˾����,
       t.unitshortname as ��˾���,
       t.fathercorp ������˾����,
       t.busibegindate as ��ʼ����,
       t.isworkingunit as �Ƿ���Ч,
       t.dr,
       t.ts,
       t.holdflag,
       t.isuseretail,
       t.innercode,
       t.maxinnercode,
       t.ownersharerate,
       t.saleaddr
  from bd_corp t order by t.unitcode;

--������Ϣ
select --t.pk_corp,
 t1.unitcode    as ��˾����,
 t1.unitname    as ��˾����,
 t.pk_deptdoc   as ��������,
 t.deptcode     as ���ű���,
 t.deptname     as ��������,
 t.deptattr     as ,
 t.depttype     as �Ƿ�����,
 t.def1         as ��������,
 t.def2         as �칫�ص�,
 t.def3         as �������,
 t.memo         as ��ע,
 t.pk_fathedept as ��������,
 t.pk_psndoc,
 t.pk_psndoc2,
 t.pk_psndoc3,
 t.createdate   as ��������,
 t.canceled     as �Ƿ�ȡ��,
 t.hrcanceled   as �Ƿ�HRȡ��,
 t.innercode,
 t.isuseretail,
 t.maxinnercode,
 t.dr,
 t.ts
  from bd_deptdoc t, bd_corp t1
 where t.pk_corp = t1.pk_corp
   and t1.unitcode = '1';

--Ա����Ϣ��
select t.pk_psndoc     as Ա����Ϣ������,
       t.psncode       as Ա������,
       t.psnname       as Ա������,
       t.psnnamepinyin as Ա��ƴ��,
       t3.psnclasscode as Ա�����,
       t3.psnclassname as Ա���������,
       t1.unitcode     as ��˾����,
       t1.unitname     as ��˾����,
       t2.deptcode     as ���ű���,
       t2.deptname     as ��������,
       t.regular as �Ƿ�ת��,
       t.regulardata as ת������,
       t.groupdef2 as ת�����,
       --t.pk_om_job     as ��λ,
       t4.jobcode      as ְλ����,
       t4.jobname      as ְλ����,
       --t.jobseries as ��λ����,
       t.indutydate as ��ְ����,
       --t.pk_psnbasdoc  as ������Ϣ������,
       t.psnclscope,
       t.dutyname as ��λ����, 
       t.groupdef1 as ��������,
       t.createtime as ����ʱ��,
       t.creator as ������Ա,
       t.modifier as �޸���Ա,
       t.modifytime as �޸�ʱ��,
       t.hroperator as HR������Ա,
       t.iscalovertime,
       t.isreturn as �Ƿ�Ƹ,
       t.onpostdate as ��������,
       t.poststat,
       t.showorder,
       t.tbm_prop,
       t.clerkflag,
       t.indocflag,
       t.series as ����,
       t.jobrank  as ��λ����,
       t.dr,
       t.ts
  from BD_PSNDOC t, bd_corp t1, bd_deptdoc t2, bd_psncl t3,om_job t4
 where t.pk_corp = t1.pk_corp
   and t1.unitcode = '1'
   and t.pk_deptdoc = t2.pk_deptdoc
   and t.pk_psncl = t3.pk_psncl
   and t.pk_om_job = t4.pk_om_job
   and t.psnname = '����';

select * from bd_psndoc t where t.psnname = '����';
select * from bd_psncl t where t.pk_psncl = '0001XT100000000000RR';

--������Ϣ��
select t.pk_corp       as ������˾,
       t1.unitname      as ��˾����,
       t.pk_psnbasdoc  as ��Ϣ����,
       t.psnname       as Ա������,
       t.sex           as �Ա�,
       t.ssnum         as ���֤��,
       t.id            as ���֤��,
       t.birthdate     as ��������,
       t.email         as �ʼ���ַ,
       t.addr          as ��ַ,
       t.dr,
       t.postalcode    as �ʱ�,
       t.homephone     as ��ͥ�绰,
       t.joinworkdate  as �μӹ�������,
       t.mobile        as �ֻ�,
       t.officephone   as �칫�绰,
       t.nationality   as ����,
       t.nativeplace   as ����,
       t.createtime    as ��������,
       t.creator       as ������Ա,
       t.modifier      as �޸���Ա,
       t.modifytime    as �޸�ʱ��,
       t.hroperator    as HR������Ա,
       t.joinsysdate   as ��������,
       t.basgroupdef1 as ������,
       t.basgroupdef8 as ѧ��,
       t.marital as ����״��,
       t.permanreside as ��ס��,
       t.polity as ������ò,
       t.ts,
       t.approveflag,
       t.basgroupdef10,
       t.basgroupdef5,
       t.basgroupdef7,
       t.basgroupdef9,
       t.indocflag,
       t.basgroupdef3 as ����ת��ת��
  from bd_psnbasdoc t,bd_corp t1
 where t.pk_corp = t1.pk_corp and t1.unitcode = '1' and t.psnname = '���' ;

--ְλ��Ϣ��
select t.pk_om_job as ְλ����,
       t.jobcode   as ְλ����,
       t.jobname   as ְλ����,
       --t.pk_corp as ��˾����,
       t1.unitcode as ��˾����,
       t1.unitname as ��˾����,
       --t.pk_deptdoc   as ��������,
       t2.deptcode as ���ű���,
       t2.deptname as ��������,
       t.suporior  as �ϼ�ְλ,
       --t.jobseries    as ְλ����,
       t3.doccode     as ְλ���б���,
       t3.docname     as ְλ��������,
       t.isabort      as �Ƿ���ֹ,
       t.abortdate    as ��ֹ����,
       t.builddate    as ��������,
       t.createcorp   as ������˾,
       t.isdeptrespon,
       t.jobrank,
       t.dr,
       t.ts
  from om_job t, bd_corp t1, bd_deptdoc t2, bd_defdoc t3
 where t.pk_corp = t1.pk_corp
   and t.pk_deptdoc = t2.pk_deptdoc
   and t.jobseries = t3.pk_defdoc
   and t1.unitcode = '1';
   
--��Ա��ְ��Ϣ
select
    --t.pk_psndoc      as Ա������,
     t1.psncode      as Ա������,
     t1.psnname      as Ա������,
     t.pk_psndoc_sub,
     t.pk_psnbasdoc  as Ա��������Ϣ����,
     t.type           as �䶯����,
     t2.doccode       as �䶯���ͱ���,
     t2.docname       as �䶯����˵��,
     t.psnclbefore    as �䶯ǰԱ�����,
     t.psnclafter     as �䶯��Ա�����,
     t.pk_corp        as �䶯ǰ��˾����,
     t.pk_corpafter   as �䶯��˾����,
     t.pkdeptbefore   as �䶯ǰ��������,
     t.pkdeptafter    as �䶯��������,
     t.pkomdutybefore,
     t.pkpostbefore,
     t.poststat,
     t.isreturn       as �Ƿ�Ƹ,
     t.lastflag       as �Ƿ�����ʶ,
     t.leavedate      as �뿪����,
     t.reason         as �䶯ԭ��,
     t.recordnum,
     t.salarystopdate as ���нˮ����,
     t.hroperator     as HR������Ա,
     t.dr,
     t.ts
  from HI_PSNDOC_DIMISSION t, bd_psndoc t1, bd_defdoc t2
 where t.pk_psndoc = t1.pk_psndoc
   and t.type = t2.pk_defdoc and t.pk_psndoc = '0001Q010000000001NJZ';

select * from bd_deptdoc t where t.pk_deptdoc = '1001XT1000000000004E';

--��λ�䶯��ˮ
select
--t.pk_corp ,
 t1.unitcode as ��˾����,
 t1.unitname as ��˾����,
 --t.pk_deptdoc,
 t2.deptcode    as ���ű���,
 t2.deptname    as ��������,
 t.pk_detytype  as ��������,
 t.pk_dutyrank,
 t.pk_jobrank,
 t.pk_jobserial,
 t.jobtype,
 t.pk_om_duty as ��λ����,
 t3.dutycode  as ��λ����,
 t3.dutyname  as ��λ����,
 t.pk_postdoc,
 --t.pk_psndoc,
 t4.psncode      as Ա������,
 t4.psnname      as Ա������,
 t.pk_psndoc_sub,
 t.pk_psncl      as Ա������,
 --t.pk_psnbasdoc,
 t.approveflag   as �Ƿ�ͬ���־,
 t.begindate     as ��ʼ����,
 t.enddate       as ��������,
 t.lastflag      as ����־,
 t.isreturn      as �Ƿ�Ƹ,
 t.hroperator    as HR����Ա,
 t.dr,
 t.ts,
 t.poststat,
 t.preparereason,
 t.preparetype,
 t.recordnum,
 t.tbm_prop,
 t.bendflag,
 t.iscalovertime
  from hi_psndoc_deptchg t,
       bd_corp           t1,
       bd_deptdoc        t2,
       om_duty           t3,
       bd_psndoc         t4
 where t.pk_corp = t1.pk_corp
   and t1.unitcode = '1'
   and t.pk_deptdoc = t2.pk_deptdoc
   and t.pk_om_duty = t3.pk_om_duty
   and t.pk_psndoc = t4.pk_psndoc
   and t.pk_psndoc = '0001Q010000000001NJZ' order by t.begindate;

select * from BD_DEFDOC t where t.pk_defdoc in ('0001XT100000000000PX');
select * from bd_defdoc t where t.pk_defdoclist = 'HI000000000000000051';

select * from om_job t where t.pk_jobdoc = '1001XT1000000000004P';0001XT100000000000QG 0001Q010000000004W5L
select * from om_job t where t.pk_om_duty = '1001XT1000000000004P';
select * from om_duty t where t.pk_om_duty in( '0001XT10000000000GGE','0001XT10000000000GGF');

select t.pk_psndoc from hi_psndoc_deptchg t group by t.pk_psndoc having count(*) > 6;

select * from hi_psndoc_family t where t.pk_psndoc = '1001XT100000000000SI';
select * from hi_psndoc_training t where t.pk_psndoc = '1001XT100000000000SI';

--Ա����ְ
select s.begindate as ��ְ����,
       s.enddate   as ��ͬ��������,
       s2.unitcode as ��˾����,
       s2.unitname as ��˾����,
       s3.deptcode as ���ű���,
       s3.deptname as ��������,
       s1.psncode  as Ա������,
       s1.psnname  as Ա������,
       s4.dutycode as ��λ����,
       s4.dutyname as ��λ����,
       s5.psnclasscode as Ա�����ͱ���,
       s5.psnclassname as Ա����������
  from (select row_number() over(partition by t.pk_psndoc order by t.begindate) as l_rn,
               t.*
          from hi_psndoc_deptchg t) s,
       bd_psndoc s1,
       bd_corp s2,
       bd_deptdoc s3,
       om_duty s4,
       bd_psncl s5
 where s.l_rn = 1
   and s.pk_psndoc = s1.pk_psndoc
   and s.pk_corp = s2.pk_corp
   and s.pk_deptdoc = s3.pk_deptdoc 
   and s.pk_om_duty = s4.pk_om_duty
   and s.pk_psncl = s5.pk_psncl
   order by s.begindate;
   
select t1.pk_psndoc
  from (select distinct t.pk_psndoc, t.pk_psncl from hi_psndoc_deptchg t) t1
 group by t1.pk_psndoc
having count(*) > 1;

select * from hi_psndoc_deptchg t where t.pk_psndoc = '1001XT100000000000ZE';

select * from bd_psncl t where t.pk_psncl in ('0001XT100000000000RR','0001XT100000000000RT');

--��ְ��Ϣ
SELECT HI_PSNDOC_DEPTCHG.BEGINDATE as BEGINDATE,
       BD_PSNDOC.PSNCODE as PSNCODE,
       BD_PSNDOC.PSNNAME as PSNNAME,
       BD_CORP.UNITCODE as UNITCODE,
       BD_DEPTDOC.DEPTCODE as DEPTCODE,
       BD_PSNCL.PSNCLASSCODE as PSNCLASSCODE,
       OM_DUTY.DUTYCODE as DUTYCODE
  FROM (select row_number() over(partition by t.pk_psndoc order by t.begindate) as l_rn,
               t.*
          from hi_psndoc_deptchg t) HI_PSNDOC_DEPTCHG,
       BD_PSNDOC,
       BD_CORP,
       BD_DEPTDOC,
       BD_PSNCL,
       OM_DUTY
 where HI_PSNDOC_DEPTCHG.l_rn = 1
   and HI_PSNDOC_DEPTCHG.Pk_Corp = BD_CORP.Pk_Corp
   and HI_PSNDOC_DEPTCHG.Pk_Deptdoc = BD_DEPTDOC.Pk_Deptdoc
   and HI_PSNDOC_DEPTCHG.Pk_Psndoc = BD_PSNDOC.Pk_Psndoc
   and HI_PSNDOC_DEPTCHG.Pk_Psncl = BD_PSNCL.Pk_Psncl
   and HI_PSNDOC_DEPTCHG.pk_om_duty = OM_DUTY.pk_om_duty;
