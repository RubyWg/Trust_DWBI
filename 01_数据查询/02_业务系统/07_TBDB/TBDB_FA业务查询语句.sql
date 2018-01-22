--��ֵ������Ϣ
SELECT FA_FUNDINFO.C_FUNDID, --����ID
       FA_FUNDINFO.C_FUNDNAME, --��������
       FA_FUNDINFO.L_BUSISCOPE, --ҵ��Χ
       FA_FUNDINFO.C_PROJCODE, --��Ŀ����
       FA_FUNDINFO.C_CYKIND, --����
       FA_FUNDINFO.L_ASTYPE, --��������
       FA_FUNDINFO.C_SUPERIOR, --��������
       FA_FUNDINFO.L_TMPLID, --ģ�壬Ĭ��Ϊ9992
       FA_FUNDINFO.D_DESTORY, --��������
       FA_FUNDINFO.L_VOID, --�Ƿ���Ч
       FA_FUNDINFO.C_FUNDCODE --��Ʒ����
  FROM FA_FUNDINFO
 WHERE FA_FUNDINFO.L_VOID = 0
   and FA_FUNDINFO.L_ASTYPE <> 1
   and FA_FUNDINFO.C_FUNDID = '258';

--ָ����ĿFA��Ŀƾ֤��ϸ
SELECT FA_VOUCHERS.C_JOURID,
       FA_VOUCHERS.D_BUSI,
       FA_VOUCHERS.C_DIGEST,
       FA_VOUCHERS.C_SUBCODE,
       FA_VOUCHERS.F_DEBIT,
       FA_VOUCHERS.F_CREDIT,
       FA_VOUCHERS.C_SUBPROP,
       FA_FUNDINFO.C_FUNDCODE,
       FA_FUNDINFO.C_PROJCODE
  FROM FA_VOUCHERS, FA_FUNDINFO
 WHERE FA_VOUCHERS.L_STATE < 32
   and FA_VOUCHERS.D_BUSI <= to_date(20160630, 'yyyymmdd')
   and FA_FUNDINFO.L_VOID = 0
   AND FA_VOUCHERS.C_FUNDID = FA_FUNDINFO.C_FUNDID
   and FA_FUNDINFO.C_PROJCODE = 'F288'
 order by FA_VOUCHERS.C_SUBCODE;
   
   
--��ѯĳ����Ŀ�µ����б����¼
select *
  from fa_vouchers t
 where t.c_fundid in (select t1.c_fundid
                        from fa_fundinfo t1
                       where t1.c_projcode = 'AVICTC2015X1083'
                         and t1.l_astype = 1)
   and t.c_subcode like '6408%'
 order by t.d_busi;

 --��Ŀ�Ƿ�ʵ��ʹ��
--���Ҵ�����ƾ֤��Ŀ�Ŀ��Ӧ�����и�����Ŀ   
SELECT FA_VOUCHERS.C_FUNDID AS C_BOOK_CODE,
       TEMP.L_SUBJ_LEVEL AS L_SUBJ_LEVEL,
       (CASE
         WHEN TEMP.L_SUBJ_LEVEL = 0 THEN
          SUBSTR(FA_VOUCHERS.C_SUBCODE, 1, 1)
         WHEN TEMP.L_SUBJ_LEVEL = FA_SUBJECT.L_LEVEL AND
              FA_SUBJECT.L_LEAF = 1 THEN
          FA_VOUCHERS.C_SUBCODE
         WHEN TEMP.L_SUBJ_LEVEL <= 4 THEN
          SUBSTR(FA_VOUCHERS.C_SUBCODE, 1, TEMP.L_SUBJ_LEVEL * 2 + 2)
         ELSE
          FA_VOUCHERS.C_SUBCODE
       END) AS C_SUBJ_CODE
  FROM (SELECT DISTINCT T.C_FUNDID, T.C_SUBCODE, T.L_STATE
          FROM FA_VOUCHERS T) FA_VOUCHERS,
       FA_SUBJECT,
       FA_FUNDINFO,
       (SELECT 0 AS L_SUBJ_LEVEL
          FROM DUAL
        UNION ALL
        SELECT 1 AS L_SUBJ_LEVEL
          FROM DUAL
        UNION ALL
        SELECT 2 AS L_SUBJ_LEVEL
          FROM DUAL
        UNION ALL
        SELECT 3 AS L_SUBJ_LEVEL
          FROM DUAL
        UNION ALL
        SELECT 4 AS L_SUBJ_LEVEL
          FROM DUAL
        UNION
        SELECT 5 AS L_SUBJ_LEVEL FROM DUAL) TEMP
 WHERE FA_VOUCHERS.L_STATE < 32
   AND FA_SUBJECT.L_CLASS <= 6
   AND FA_FUNDINFO.L_VOID = 0
   AND FA_FUNDINFO.L_ASTYPE <> 1
   AND FA_SUBJECT.L_LEVEL >= TEMP.L_SUBJ_LEVEL
   AND FA_SUBJECT.C_SUBCODE = FA_VOUCHERS.C_SUBCODE
   AND FA_VOUCHERS.C_SUBCODE = '1101013199002081'
   AND FA_VOUCHERS.C_FUNDID = '100802'
   AND FA_VOUCHERS.C_FUNDID = FA_SUBJECT.C_FUNDID
   AND FA_SUBJECT.C_FUNDID = FA_FUNDINFO.C_FUNDID;

