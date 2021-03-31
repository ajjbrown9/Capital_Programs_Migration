/*Oracle EBS OLTP connection pool*/
/*Project_Lineage_Query_Pkg2_11.13_v15*/
/*
    prj     = project
    tsk     = task
    agr     = agreement
    po      = purchase order
    dt      = date
    inv     = invoice
    ap      = account payable(s)
    ar      = account receivable(s)
    id      = specific ebs assigned row id
    no      = specific id used in the business
    cnty    = county
    rev     = revision
    descr   = description
    awd     = award
    cncl = cancle/canceled
    rtng = retainage
    amt = amount
    dist = distribution
    qty = quantity

    12/01/2020 - Added po_dist_all.REQ_DISTRIBUTION_ID --done
    12/01/2020 - Corrected PO_DISTRIBUTIONS_AWARD_ID --done
    12/01/2020 - Corrected ebs_pa_projects.column50 from LAST_UPDATED_BY to LAST_UPDATE_DATE  --done
    12/01/2020 - Corrected ebs_pa_tasks.column50 from LAST_UPDATED_BY to LAST_UPDATE_DATE --done
    12/04/2020 - Added "column12.ebs_po_header_vendor_site_id" and "column13.ebs_po_header_vendor_site_id" --done
    12/04/2020 - Added "column27.ebs_agr_vendor_site_id" and "column28.ebs_agr_vendor_contact_id" --done
    12/04/2020 - Added "column17.ap_inv_header_vendor_site_id" and "column18.ap_inv_header_vendor_contact_id" --done 
    12/04/2020 - Added ap_inv_payments CTE - done
    12/08/2020 - Re-ordered 
*/

with
    po_requisition_dists as (
        select
            4 as "ORDINAL_SORT"
            ,'REQ_DISTS' as "DATA_GROUP"
            ,'EBS\Procurement\PO_REQ_DISTRIBUTIONS_ALL\HR_ALL_ORGANIZATION_UNITS\PO_REQUISITION_LINES_ALL\GL_CODE_COMBINATIONS\GMS_AWARDS_ALL' as "DATA_SOURCE"
            ,po_req_dist.REQUISITION_LINE_ID as "column1" -- as "ebs_req_dist_ln_id"
            ,po_req_dist.DISTRIBUTION_ID as "column2" -- as "ebs_req_dist_id"
            ,po_req_dist.CODE_COMBINATION_ID as "column3" -- as "ebs_req_dist_code_id"
            ,po_req_dist.PROJECT_ID as "column4" -- as "ebs_req_dist_prj_id"
            ,po_req_dist.TASK_ID as "column5" -- as "ebs_req_dist_tsk_id"
            ,gcc.SEGMENT1 as "column6" --  as "ebs_req_dist_fund"
            ,(
                select
                    flv.description
                from apps.fnd_flex_values_vl flv
                left join apps.fnd_flex_Value_sets fvs
                    on(flv.FLEX_VALUE_SET_ID = fvs.FLEX_VALUE_SET_ID)
                where fvs.FLEX_VALUE_SET_NAME = 'CNTY_FUND'
                and flv.FLEX_VALUE = gcc.SEGMENT1   
            ) as "column7" --  as "ebs_req_dist_fund_name"
            ,gcc.SEGMENT2 as "column8" -- as "ebs_req_dist_center"
            ,(
                select
                    flv.description
                from apps.fnd_flex_values_vl flv
                left join apps.fnd_flex_Value_sets fvs
                    on(flv.FLEX_VALUE_SET_ID = fvs.FLEX_VALUE_SET_ID)
                where fvs.FLEX_VALUE_SET_NAME = 'CNTY_CENTER'
                and flv.FLEX_VALUE = gcc.SEGMENT2
            ) as "column9" --  as "ebs_req_dist_center_name"
            ,gcc.SEGMENT3 as "column10" --  as "ebs_req_dist_account"
            ,(
                select
                    flv.description
                from apps.fnd_flex_values_vl flv
                left join apps.fnd_flex_Value_sets fvs
                    on(flv.FLEX_VALUE_SET_ID = fvs.FLEX_VALUE_SET_ID)
                where fvs.FLEX_VALUE_SET_NAME = 'CNTY_ACCOUNT'
                and flv.FLEX_VALUE = gcc.SEGMENT3   
            ) as "column11" --  as "ebs_req_dist_account_name"
            ,gcc.SEGMENT4 as "column12" --  as "ebs_req_dist_sub_account"
            ,gcc.SEGMENT5 as "column13" --  as "ebs_req_dist_activity"
            ,po_req_dist.EXPENDITURE_TYPE as "column14" -- as "ebs_req_dist_exp_type"
            ,nvl(po_req_dist.REQ_LINE_QUANTITY,0) as "column15" -- as "ebs_req_dist_ln_qty"
            ,nvl(po_req_dist.REQ_LINE_AMOUNT,0) as "column16" -- as "ebs_req_dist_ln_amt"
            ,po_req_dist.REQ_AWARD_ID as "column17" -- as "ebs_req_dist_award_id"            
            ,gms_awards.AWARD_NUMBER as "column18" -- as "ebs_req_dist_award_no"
            ,po_req_dist.EXPENDITURE_ORGANIZATION_ID as "column19" -- as "ebs_req_dist_expend_org_id"
            ,hr_org.NAME as "column20" -- as "ebs_req_dist_expend_org"
            ,hr_org.ATTRIBUTE1 as "column21" -- as "ebs_req_dist_expend_admin"
            ,po_req_dist.GL_ENCUMBERED_DATE as "column22" -- as "ebs_req_dist_enc_dt"
            ,po_req_dist.GL_CANCELLED_DATE as "column23" -- as "ebs_req_dist_canceled_dt"
            ,po_req_dist.EXPENDITURE_ITEM_DATE as "column24" -- as "ebs_req_dist_expend_itm_dt"
            ,nvl(po_req_dist.ENCUMBERED_AMOUNT,0) as "column25" -- as "ebs_req_dist_enc_amt"
            ,po_req_line.BLANKET_PO_HEADER_ID as "column26" -- as "ebs_req_ln_agr_id"
            ,po_req_line.BLANKET_PO_LINE_NUM as "column27" -- as "ebs_req_ln_agr_ln_no"
            ,po_req_line.REQUISITION_HEADER_ID as "column28" -- as "ebs_req_ln_header_id"
            ,po_req_dist.CREATION_DATE as "column49" -- as "ebs_req_dist_create_dt"
            ,po_req_dist.LAST_UPDATE_DATE as "column50" -- as "ebs_req_dist_update_dt"
        from PO_REQ_DISTRIBUTIONS_ALL po_req_dist
        left join HR_ALL_ORGANIZATION_UNITS hr_org
            on
                (
                    hr_org.BUSINESS_GROUP_ID = 84
                        and
                    po_req_dist.EXPENDITURE_ORGANIZATION_ID = hr_org.ORGANIZATION_ID
                )             
        left join PO_REQUISITION_LINES_ALL po_req_line
            on
                (
                    po_req_line.ORG_ID = 102
                        and
                    po_req_dist.REQUISITION_LINE_ID = po_req_line.REQUISITION_LINE_ID                  
                )
        inner join (
                    select
                        PO_HEADERS_ALL.PO_HEADER_ID
                    from PO_HEADERS_ALL
                    where PO_HEADERS_ALL.TYPE_LOOKUP_CODE = 'BLANKET'
                    and PO_HEADERS_ALL.CANCEL_FLAG != 'Y'
                    and trunc(PO_HEADERS_ALL.END_DATE) >= trunc(sysdate)
                    and PO_HEADERS_ALL.ORG_ID = 102
                ) blanket_index
            on  (
                    blanket_index.PO_HEADER_ID = po_req_line.BLANKET_PO_HEADER_ID
                )           
        inner join GL_CODE_COMBINATIONS gcc
            on(po_req_dist.CODE_COMBINATION_ID = gcc.CODE_COMBINATION_ID)
        left join GMS_AWARDS_ALL gms_awards
            on
                (
                    gms_awards.ORG_ID = 102
                        and
                    po_req_dist.REQ_AWARD_ID = gms_awards.AWARD_ID
                )
        --where po_req_dist.GL_CANCELLED_DATE is null
        order by
            po_req_dist.REQUISITION_LINE_ID asc
            ,po_req_dist.DISTRIBUTION_ID asc
    )
--select * from po_requisition_dists

,
    po_requisition_lines as (
        select
            5 as "ORDINAL_SORT"
            ,'REQ_LINES' as "DATA_GROUP"
            ,'EBS\Procurement\PO_REQUISITION_LINES_ALL\MTL_CATEGORIES_VL\MTL_SYSTEM_ITEMS_B' as "DATA_SOURCE"
            ,po_req_line.REQUISITION_HEADER_ID as "column1" -- as "ebs_req_ln_header_id"
            ,po_req_line.REQUISITION_LINE_ID as "column2" -- as "ebs_req_ln_id"
            ,po_req_line.LINE_NUM as "column3" -- as "ebs_req_ln_no"
            ,po_req_line.ITEM_DESCRIPTION as "column4" -- as "ebs_req_ln_itm_descr"
            ,po_req_line.UNIT_MEAS_LOOKUP_CODE as "column5" -- as "ebs_req_ln_uom"
            ,nvl(po_req_line.UNIT_PRICE,0) as "column6" -- as "ebs_req_ln_up"
            ,nvl(po_req_line.QUANTITY,0) as "column7" -- as "ebs_req_ln_qty"
            ,nvl(po_req_line.QUANTITY_DELIVERED,0) as "column8" -- as "ebs_req_ln_qty_delivered"
            ,po_req_line.NEED_BY_DATE as "column9" -- as "ebs_req_ln_need_by_dt"
            ,po_req_line.NOTE_TO_AGENT as "column10" -- as "ebs_req_ln_agent_note"
            ,po_req_line.NOTE_TO_RECEIVER as "column11" -- as "ebs_req_ln_receiver_note"
            ,po_req_line.DOCUMENT_TYPE_CODE as "column12" -- as "ebs_req_ln_doc_type"
            ,po_req_line.BLANKET_PO_HEADER_ID as "column13" -- as "ebs_req_ln_agr_id"
            ,po_req_line.BLANKET_PO_LINE_NUM as "column14" -- as "ebs_req_ln_agr_ln_no"
            ,po_req_line.CANCEL_FLAG as "column15" -- as "ebs_req_ln_cncl_flg"
            ,nvl(po_req_line.QUANTITY_CANCELLED,0) as "column16" -- as "ebs_req_ln_cncl_qty"
            ,po_req_line.CANCEL_DATE as "column17" -- as "ebs_req_ln_cncl_dt"
            ,po_req_line.CANCEL_REASON as "column18" -- as "ebs_req_ln_cncl_note"
            ,po_req_line.VENDOR_ID as "column19" -- as "ebs_req_ln_vendor_id"
            ,po_req_line.VENDOR_SITE_ID as "column20" -- as "ebs_req_ln_vendor_site_id"
            ,po_req_line.VENDOR_CONTACT_ID as "column21" -- as "ebs_req_ln_vendor_contact_id"
            ,po_req_line.ATTRIBUTE1 as "column22" -- as "ebs_req_ln_dept"
            ,po_req_line.PCARD_FLAG as "column23" -- as "ebs_req_ln_pcard_flg"
            ,po_req_line.NOTE_TO_VENDOR as "column24" -- as "ebs_req_ln_vendor_note"
            ,po_req_line.ORDER_TYPE_LOOKUP_CODE as "column25" -- as "ebs_req_ln_order_type"
            ,po_req_line.PURCHASE_BASIS as "column26" -- as "ebs_req_ln_purch_basis" 
            ,nvl(po_req_line.BASE_UNIT_PRICE,0) as "column27" -- as "ebs_req_ln_base_up"
            ,po_req_line.ATTRIBUTE2 as "column28" -- as "ebs_req_ln_wo_no"
            ,nvl(nvl(po_req_line.AMOUNT,(nvl(po_req_line.UNIT_PRICE,0)*nvl(po_req_line.QUANTITY,0))),0) as "column29" -- as "ebs_req_ln_amt"
            ,po_req_line.CATEGORY_ID as "column30" -- as "ebs_req_ln_cat_id" --##NEW## 03/13/2021
            ,mtl_cat.SEGMENT1||'.'||mtl_cat.SEGMENT2 as "column31" -- as "ebs_req_ln_cat_code" --##NEW## 03/13/2021
            ,mtl_cat.DESCRIPTION as "column32" -- as "ebs_req_ln_cat_descr" --##NEW## 03/13/2021
            ,po_req_line.ITEM_ID as "column33" -- as "ebs_req_ln_item_id" --##NEW## 03/13/2021
            ,mtl_items.SEGMENT1 as "column34" -- as "ebs_req_ln_item_class_1" --##NEW## 03/13/2021
            ,mtl_items.SEGMENT2 as "column35" -- as "ebs_req_ln_item_class_2" --##NEW## 03/13/2021
            ,mtl_items.SEGMENT3 as "column36" -- as "ebs_req_ln_item_class_3" --##NEW## 03/13/2021
            ,mtl_items.DESCRIPTION as "column37" -- as "ebs_req_ln_item_descr" --##NEW## 03/13/2021
            ,po_req_line.CREATION_DATE as "column49" -- as "ebs_req_ln_create_dt"
            ,po_req_line.LAST_UPDATE_DATE as "column50" -- as "ebs_req_ln_update_dt"
        from PO_REQUISITION_LINES_ALL po_req_line
        inner join (
            select
                "column1"
            from po_requisition_dists
            group by
                "column1"   
        ) return_po_dist_line_id
            on
                (
                    po_req_line.ORG_ID = 102
                        and
                    po_req_line.REQUISITION_LINE_ID = return_po_dist_line_id."column1"
                )
        left join mtl_categories_vl mtl_cat
            on(po_req_line.CATEGORY_ID = mtl_cat.CATEGORY_ID)
        left join MTL_SYSTEM_ITEMS_B mtl_items
            on
                (
                    mtl_items.ORGANIZATION_ID = 104
                        and
                    po_req_line.ITEM_ID = mtl_items.INVENTORY_ITEM_ID
                )  
        where po_req_line.CANCEL_FLAG != 'Y'          
        order by
            po_req_line.REQUISITION_HEADER_ID asc
            ,po_req_line.REQUISITION_LINE_ID asc
    )
--select * from po_requisition_lines
,
    po_requisition_headers as (
        select
            6 as "ORDINAL_SORT"
            ,'REQ_HEADERS' as "DATA_GROUP"
            ,'EBS\Procurement\PO_REQUISITION_HEADERS_ALL' as "DATA_SOURCE"
            ,po_req_header.REQUISITION_HEADER_ID as "column1" -- as "ebs_req_header_id"
            ,po_req_header.SEGMENT1 as "column2" -- as "ebs_req_header_no"
            ,po_req_header.AUTHORIZATION_STATUS as "column3" -- as "ebs_req_auth_status"
            ,po_req_header.DESCRIPTION as "column4" -- as "ebs_req_header_descr"
            ,po_req_header.NOTE_TO_AUTHORIZER as "column5" -- as "ebs_req_header_auth_note"
            ,po_req_header.CANCEL_FLAG as "column6" -- as "ebs_req_header_cncl_flg"
            ,po_req_header.CLOSED_CODE as "column7" -- as "ebs_req_header_clsd_code"
            ,po_req_header.APPROVED_DATE as "column8" -- as "ebs_req_header_appr_dt"
            ,po_req_header.CREATION_DATE as "column49" -- as "ebs_req_header_create_dt"
            ,po_req_header.LAST_UPDATE_DATE as "column50" -- as "ebs_req_header_update_dt"
        from PO_REQUISITION_HEADERS_ALL po_req_header
        inner join (
            select
                "column1"
            from po_requisition_lines
            group by "column1"
        ) req_lines
            on
                (
                    po_req_header.ORG_ID = 102
                        and
                    po_req_header.REQUISITION_HEADER_ID = req_lines."column1"
                )
        where po_req_header.CANCEL_FLAG != 'Y'
        order by
            po_req_header.REQUISITION_HEADER_ID asc
    )
--select * from po_requisition_headers
,
    ebs_po_dist as (
        select
            7 as "ORDINAL_SORT"
            ,'PO_DISTS' as "DATA_GROUP"
            ,'EBS\Purchasing\PO_DISTRIBUTIONS_ALL\PO_LINES_ALL\GL_CODE_COMBINATIONS\GMS_AWARD_DISTRIBUTIONS\GMS_AWARDS_ALL\HR_ALL_ORGANIZATION_UNITS' as "DATA_SOURCE"            
            ,po_dist.PO_HEADER_ID as "column1" -- as "ebs_po_dist_po_header_id"
            ,po_dist.PO_LINE_ID as "column2" --  as "ebs_po_dist_po_line_id"
            ,po_dist.PO_DISTRIBUTION_ID as "column3" --  as "ebs_po_dist_id"
            ,po_dist.CODE_COMBINATION_ID as "column4" --  as "ebs_po_dist_code_combo"
            ,po_dist.DISTRIBUTION_TYPE as "column5" --  as "ebs_po_dist_type"
            ,gcc.SEGMENT1 as "column6" --  as "ebs_po_dist_fund"
            ,(
                select
                    flv.description
                from apps.fnd_flex_values_vl flv
                left join apps.fnd_flex_Value_sets fvs
                    on(flv.FLEX_VALUE_SET_ID = fvs.FLEX_VALUE_SET_ID)
                where fvs.FLEX_VALUE_SET_NAME = 'CNTY_FUND'
                and flv.FLEX_VALUE = gcc.SEGMENT1   
            ) as "column7" --  as "ebs_po_dist_fund_name"
            ,gcc.SEGMENT2 as "column8" -- as "ebs_po_dist_center"
            ,(
                select
                    flv.description
                from apps.fnd_flex_values_vl flv
                left join apps.fnd_flex_Value_sets fvs
                    on(flv.FLEX_VALUE_SET_ID = fvs.FLEX_VALUE_SET_ID)
                where fvs.FLEX_VALUE_SET_NAME = 'CNTY_CENTER'
                and flv.FLEX_VALUE = gcc.SEGMENT2   
            ) as "column9" --  as "ebs_po_dist_center_name"
            ,gcc.SEGMENT3 as "column10" --  as "ebs_po_dist_account"
            ,(
                select
                    flv.description
                from apps.fnd_flex_values_vl flv
                left join apps.fnd_flex_Value_sets fvs
                    on(flv.FLEX_VALUE_SET_ID = fvs.FLEX_VALUE_SET_ID)
                where fvs.FLEX_VALUE_SET_NAME = 'CNTY_ACCOUNT'
                and flv.FLEX_VALUE = gcc.SEGMENT3   
            ) as "column11" --  as "ebs_po_dist_account_name"
            ,gcc.SEGMENT4 as "column12" --  as "ebs_po_dist_sub_account"
            ,gcc.SEGMENT5 as "column13" --  as "ebs_po_dist_activity"
            ,awards_all.AWARD_ID as "column14" -- as "ebs_po_dist_award_id"
            ,nvl(po_dist.ENCUMBERED_AMOUNT,0) as "column15" -- as "ebs_po_dist_enc_amt"
            ,nvl(po_dist.UNENCUMBERED_AMOUNT,0) as "column16" -- as "ebs_po_dist_unenc_amt"
            ,nvl(po_dist.AMOUNT_TO_ENCUMBER,0) as "column17" -- as "ebs_po_dist_to_enc_amt"
            ,nvl(po_dist.AMOUNT_ORDERED,0) as "column18" -- as "ebs_po_dist_ordered_amt"
            ,nvl(po_dist.AMOUNT_DELIVERED,0) as "column19" -- as "ebs_po_dist_delivered_amt"
            ,nvl(po_dist.AMOUNT_CANCELLED,0) as "column20" -- as "ebs_po_dist_amt_cncl"
            ,nvl(po_dist.AMOUNT_REVERSED,0) as "column21" -- as "ebs_po_dist_amt_reversed"
            ,nvl(po_dist.RETAINAGE_RELEASED_AMOUNT,0) as "column22" -- as "ebs_po_dist_rtng_released"
            ,nvl(po_dist.RETAINAGE_WITHHELD_AMOUNT,0) as "column23" -- as "ebs_po_dist_rtng_withheld"
            ,nvl(po_dist.AMOUNT_BILLED,0) as "column24" -- as "ebs_po_dist_amt_billed"
            ,nvl(po_dist.QUANTITY_ORDERED,0) as "column25" -- as "ebs_po_dist_qty_ordered"
            ,nvl(po_dist.UNENCUMBERED_QUANTITY,0) as "column26" -- as "ebs_po_dist_qty_unenc"
            ,nvl(po_dist.QUANTITY_DELIVERED,0) as "column27" -- as "ebs_po_dist_qty_delivered"
            ,nvl(po_dist.QUANTITY_BILLED,0) as "column28" -- as "ebs_po_dist_qty_billed"
            ,nvl(po_dist.QUANTITY_CANCELLED,0) as "column29" -- as "ebs_po_dist_qty_canceled"
            ,po_dist.PROJECT_ID as "column30" -- as "ebs_po_dist_prj_id"
            ,po_dist.TASK_ID as "column31" -- as "ebs_po_dist_tsk_id"
            ,po_dist.REQ_DISTRIBUTION_ID as "column32" -- as "ebs_po_dist_req_dist_id"
            ,po_dist.EXPENDITURE_ORGANIZATION_ID as "column33" -- as "ebs_po_dist_org_expend_id"
            ,hr_org.NAME as "column34" -- as "ebs_po_dist_expend_org"
            ,hr_org.ATTRIBUTE1 as "column35" -- as "ebs_po_dist_expend_admin"
            ,nvl(nvl(po_line.CONTRACT_ID,po_line.FROM_HEADER_ID),blanket_index.FROM_HEADER_ID) as "column36" -- as "ebs_po_ln_agr_id"
            ,awards_all.AWARD_NUMBER as "column37" -- as "ebs_po_dist_award_no"
            ,po_dist.EXPENDITURE_TYPE as "column38" -- as "ebs_po_dist_expend_type" --##NEW## 3/10/2021
            ,po_dist.EXPENDITURE_ITEM_DATE as "column39" -- as "ebs_po_dist_expend_dt" --##NEW## 3/10/2021
            ,po_dist.CREATION_DATE as "column49" -- as "po_dist_create_dt"
            ,po_dist.LAST_UPDATE_DATE as "column50" -- as "po_dist_update_dt"
        from PO_DISTRIBUTIONS_ALL po_dist
        inner join PO_LINES_ALL po_line
            on
                (
                    po_line.ORG_ID =102
                        and
                    po_dist.PO_HEADER_ID = po_line.PO_HEADER_ID
                        and
                    po_dist.PO_LINE_ID = po_line.PO_LINE_ID
                        and
                    po_line.CANCEL_FLAG != 'Y'
                )
        inner join (
                    select
                        PO_HEADERS_ALL.PO_HEADER_ID
                        ,PO_HEADERS_ALL.FROM_HEADER_ID
                    from PO_HEADERS_ALL
                    where PO_HEADERS_ALL.TYPE_LOOKUP_CODE = 'BLANKET'
                    and PO_HEADERS_ALL.CANCEL_FLAG != 'Y'
                    and trunc(PO_HEADERS_ALL.END_DATE) >= trunc(sysdate)
                    and PO_HEADERS_ALL.ORG_ID = 102
                ) blanket_index
            on  (
                    blanket_index.PO_HEADER_ID = po_line.FROM_HEADER_ID
                )    
        inner join GL_CODE_COMBINATIONS gcc
            on(po_dist.CODE_COMBINATION_ID = gcc.CODE_COMBINATION_ID)           
        left join GMS_AWARD_DISTRIBUTIONS gms_award_dist
            on(po_dist.AWARD_ID = gms_award_dist.AWARD_SET_ID)            
        left join GMS_AWARDS_ALL awards_all
            on
                (
                    awards_all.ORG_ID = 102
                        and
                    gms_award_dist.AWARD_ID = awards_all.AWARD_ID
                )
        left join HR_ALL_ORGANIZATION_UNITS hr_org
            on
                (
                    hr_org.BUSINESS_GROUP_ID = 84
                        and
                    po_dist.EXPENDITURE_ORGANIZATION_ID = hr_org.ORGANIZATION_ID
                )
        order by
            po_dist.PO_HEADER_ID asc
            ,po_dist.PO_LINE_ID asc
            ,po_dist.PO_DISTRIBUTION_ID asc
    )
--select * from ebs_po_dist
,
    ebs_po_lines as (
        select
            8 as "ORDINAL_SORT"
            ,'PO_LINES' as "DATA_GROUP"
            ,'EBS\Purchasing\PO_LINES_ALL\MTL_CATEGORIES_VL\MTL_SYSTEM_ITEMS_B' as "DATA_SOURCE"
            ,po_line.PO_HEADER_ID as "column1" -- as "ebs_po_ln_header_id"
            ,po_line.PO_LINE_ID as "column2" -- as "ebs_po_ln_ln_id"
            ,po_line.LINE_NUM as "column3" -- as "ebs_po_ln__no"
            ,nvl(nvl(po_line.CONTRACT_ID,po_line.FROM_HEADER_ID),po_header.FROM_HEADER_ID) as "column4" -- as "ebs_po_ln_agr_id"
            ,po_line.CLOSED_FLAG as "column5" -- as "ebs_po_ln_close" 
            ,po_line.CANCEL_FLAG as "column6" -- as "ebs_po_ln_cncl_flg"
            ,po_line.ITEM_DESCRIPTION as "column7" -- as "ebs_po_ln_descr"
            ,nvl(po_line.RETAINAGE_RATE,0) as "column8" -- as 'ebs_po_ln_rtng_rt'
            ,po_line.UNIT_MEAS_LOOKUP_CODE as "column9" -- as "ebs_po_ln_unit_lookup"
            ,po_line.UNIT_PRICE as "column10" -- as "ebs_po_ln_unit_price"
            ,po_line.QUANTITY as "column11" -- as "ebs_po_ln_qty"
            ,po_line.AMOUNT as "column11a"
            ,po_line.MATCHING_BASIS as "column12" -- as "ebs_po_ln_matching_basis"
            ,po_line.CANCEL_DATE as "column13" -- as "ebs_po_ln_cancel_dt"
            ,po_line.CANCEL_REASON as "column14" -- as "ebs_po_ln_cancel_descr"
            ,po_line.CLOSED_DATE as "column15" -- as "ebs_po_ln_close_dt"
            ,po_line.CLOSED_REASON as "column16" -- as "ebs_po_ln_close_descr"
            ,nvl(po_line.clm_total_amount_ordered,0) as "column17" --nvl(nvl(po_line.clm_total_amount_ordered,(nvl(po_line.UNIT_PRICE,0)*nvl(po_line.QUANTITY,0))),0) as "column17" -- as "ebs_po_ln_amt"
            ,po_line.CATEGORY_ID as "column18" -- as "ebs_po_ln_cat_id" --##NEW## 03/10/2021
            ,mtl_cat.SEGMENT1||'.'||mtl_cat.SEGMENT2 as "column19" -- as "ebs_po_ln_cat_code" --##NEW## 03/10/2021
            ,mtl_cat.DESCRIPTION as "column20" -- as "ebs_po_ln_cat_descr" --##NEW## 03/10/2021
            ,po_line.ITEM_ID as "column21" -- as "ebs_po_ln_item_id" --##NEW## 03/10/2021
            ,mtl_items.SEGMENT1 as "column22" -- as "ebs_po_ln_item_class_1" --##NEW## 03/13/2021
            ,mtl_items.SEGMENT2 as "column23" -- as "ebs_po_ln_item_class_2" --##NEW## 03/13/2021
            ,mtl_items.SEGMENT3 as "column24" -- as "ebs_po_ln_item_class_3" --##NEW## 03/13/2021
            ,mtl_items.DESCRIPTION as "column25" -- as "ebs_po_ln_item_descr" --##NEW## 03/13/2021
            ,po_line.CREATION_DATE as "column49" -- as "po_ln_create_dt"
            ,po_line.LAST_UPDATE_DATE as "column50" -- as "po_ln_update_dt"
        from PO_LINES_ALL po_line
        inner join (
            select
                "column1"
                ,"column2"
            from ebs_po_dist
            group by
                "column1"
                ,"column2"
        ) return_dist_line
            on(
                po_line.ORG_ID = 102
                    and 
                po_line.PO_HEADER_ID = return_dist_line."column1"
                    and
                po_line.PO_LINE_ID = return_dist_line."column2"
            )
        inner join PO_HEADERS_ALL po_header
            on(po_line.PO_HEADER_ID = po_header.PO_HEADER_ID)
        left join MTL_CATEGORIES_VL mtl_cat
            on(po_line.CATEGORY_ID = mtl_cat.CATEGORY_ID)
        left join MTL_SYSTEM_ITEMS_B mtl_items
            on
                (
                    mtl_items.ORGANIZATION_ID = 104
                        and
                    po_line.ITEM_ID = mtl_items.INVENTORY_ITEM_ID
                )
        where po_line.CANCEL_FLAG != 'Y'
        order by
            po_line.PO_HEADER_ID asc
            ,po_line.PO_LINE_ID asc
    )
--select * from ebs_po_lines
,
    ebs_po_headers as (
        select
            9 as "ORDINAL_SORT"
            ,'PO_HEADERS' as "DATA_GROUP"
            ,'EBS\Purchasing\PO_HEADERS_ALL\PON_AUCTION_HEADERS_ALL\PON_BID_HEADERS\PER_ALL_PEOPLE_F\PER_ALL_ASSIGNMENTS_F\HR_ALL_POSITIONS_F\HR_ALL_ORGANIZATION_UNITS' as "DATA_SOURCE"            
            ,po_header.PO_HEADER_ID as "column1" -- as "ebs_po_header_id"
            ,po_header.SEGMENT1 as "column2" -- as "ebs_po_header_po_no"
            ,po_header.CANCEL_FLAG as "column3" -- as "ebs_po_header_cncl_flg"
            ,po_header.AUTHORIZATION_STATUS as "column4" -- as "ebs_po_header_auth_status"
            ,po_header.APPROVED_DATE as "column5" -- as "ebs_po_header_approved_dt"
            ,po_header.CLOSED_CODE as "column6" -- as "ebs_po_header_closed_code"
            ,po_header.CLOSED_DATE as "column7" -- as "ebs_po_header_closed_dt"
            ,po_header.COMMENTS as "column8" -- as "ebs_po_header_title"
            ,po_header.REVISION_NUM as "column9" -- as "ebs_po_header_rev_no"
            ,po_header.REVISED_DATE as "column10" -- as "ebs_po_header_rev_dt"
            ,po_header.VENDOR_ID as "column11" -- as "ebs_po_header_vendor_id"
            ,po_header.VENDOR_SITE_ID as "column12" -- as "ebs_po_header_vendor_site_id"
            ,po_header.VENDOR_CONTACT_ID as "column13" -- as "ebs_po_header_vendor_contact_id"
            ,po_header.ATTRIBUTE3 as "column14" -- as "ebs_po_header_doc_no" ##NEW## 3/10/2021
            ,po_header.ATTRIBUTE4 as "column15" -- as "ebs_po_header_bid_src" ##NEW## 3/10/2021
            ,po_header.ATTRIBUTE5 as "column16" -- as "ebs_po_header_bid_no" ##NEW## 3/10/2021
            ,agreement_agent.FULL_NAME as "column17" -- as "ebs_po_header_agent" ##NEW## 3/10/2021
            ,po_header.ATTRIBUTE9 as "column18" -- as "ebs_po_header_renew_code" ##NEW## 3/10/2021
            ,agreement_manager.FULL_NAME as "column19" -- as "ebs_po_header_manager" ##NEW## 3/10/2021
            ,agreement_dept.NAME as "column20" -- as "ebs_po_header_managing_dept" ##NEW## 3/10/2021
            ,po_header.TYPE_LOOKUP_CODE as "column21" -- as "ebs_po_header_type" ##NEW## 3/10/2021
            ,ebs_bid_header.AUCTION_HEADER_ID as "column22" -- as "ebs_po_header_auc_header_id" --##NEW## 3/10/2021
            ,ebs_bid_header.BID_NUMBER as "column23" -- as "ebs_po_header_bid_id" --##NEW## 3/10/2021
            ,po_header.FROM_HEADER_ID as "column24" -- as "ebs_po_header_from_header" --##NEW## 3/19/2021
            ,po_doc_type.STYLE_DESCRIPTION as "column25" -- as "ebs_po_header_doc_type" --##NEW## 3/19/2021
            ,po_header.CREATION_DATE as "column49" -- as "ebs_po_header_create_dt"
            ,po_header.LAST_UPDATE_DATE as "column50" -- as "ebs_po_header_update_dt"
        from PO_HEADERS_ALL po_header
        inner join (            
            select
                "column1"
            from ebs_po_lines
            group by
                "column1"            
        ) return_po_header_id
            on(
                po_header.ORG_ID = 102
                    and
                po_header.PO_HEADER_ID = return_po_header_id."column1"
                    and
                po_header.TYPE_LOOKUP_CODE = 'BLANKET'
            )
        left join PON_AUCTION_HEADERS_ALL ebs_auction_header
            on(po_header.ATTRIBUTE5 = ebs_auction_header.DOCUMENT_NUMBER)
        left join PO_DOC_STYLE_HEADERS po_doc_type
            on(po_header.STYLE_ID = po_doc_type.STYLE_ID)
        left join PON_BID_HEADERS ebs_bid_header
            on
                (
                    ebs_auction_header.AUCTION_HEADER_ID = ebs_bid_header.AUCTION_HEADER_ID
                        and
                    po_header.VENDOR_ID = ebs_bid_header.VENDOR_ID
                        and
                    po_header.VENDOR_SITE_ID = ebs_bid_header.VENDOR_SITE_ID
                )
        left join PER_ALL_PEOPLE_F agreement_agent
            on(
                po_header.AGENT_ID = agreement_agent.PERSON_ID
                    and
                trunc(sysdate)
                    between
                trunc(agreement_agent.EFFECTIVE_START_DATE)
                    and
                trunc(agreement_agent.EFFECTIVE_END_DATE)   
            )
        left join PER_ALL_PEOPLE_F agreement_manager
            on(
                po_header.ATTRIBUTE2 = agreement_manager.PERSON_ID
                    and
                trunc(sysdate)
                    between
                trunc(agreement_manager.EFFECTIVE_START_DATE)
                    and
                trunc(agreement_manager.EFFECTIVE_END_DATE)
            )
        left join PER_ALL_ASSIGNMENTS_F per_all_assign
            on(
                agreement_manager.PERSON_ID = per_all_assign.PERSON_ID
                    and
                trunc(sysdate)
                    between
                trunc(per_all_assign.EFFECTIVE_START_DATE)
                    and
                trunc(per_all_assign.EFFECTIVE_END_DATE)
                    and
                per_all_assign.ASSIGNMENT_TYPE = 'E'
            )
        left join HR_ALL_POSITIONS_F hr_all_pos
            on(
                per_all_assign.POSITION_ID = hr_all_pos.POSITION_ID
                    and
                trunc(sysdate)
                    between
                trunc(hr_all_pos.EFFECTIVE_START_DATE)
                    and
                trunc(hr_all_pos.EFFECTIVE_END_DATE)
            )
        left join HR_ALL_POSITIONS_F hr_all_pos
            on(
                per_all_assign.POSITION_ID = hr_all_pos.POSITION_ID
                    and
                trunc(sysdate)
                    between
                trunc(hr_all_pos.EFFECTIVE_START_DATE)
                    and
                trunc(hr_all_pos.EFFECTIVE_END_DATE)
            )
        left join HR_ALL_ORGANIZATION_UNITS agreement_dept
            on(
                hr_all_pos.ORGANIZATION_ID = agreement_dept.ORGANIZATION_ID
                    and
                trunc(sysdate)
                    between
                trunc(agreement_dept.DATE_FROM)
                    and
                trunc(nvl(agreement_dept.DATE_TO,sysdate))
            )
        where po_header.CANCEL_FLAG != 'Y'
        order by
            ebs_bid_header.AUCTION_HEADER_ID asc
            ,ebs_bid_header.BID_NUMBER asc
            ,po_header.PO_HEADER_ID asc
            ,po_header.VENDOR_ID asc
            ,po_header.VENDOR_SITE_ID asc
    )
--select * from ebs_po_headers
,
    ebs_po_agreements as (       
        select
            10 as "ORDINAL_SORT"
            ,'PO_AGREEMENTS' as "DATA_GROUP"
            ,'EBS\Purchasing\PO_HEADERS_ALL\PON_AUCTION_HEADERS_ALL\PON_BID_HEADERS\PER_ALL_PEOPLE_F\PER_ALL_ASSIGNMENTS_F\HR_ALL_POSITIONS_F\HR_ALL_ORGANIZATION_UNITS' as "DATA_SOURCE"                                     
            ,po_agreement.PO_HEADER_ID as "column1" -- as "ebs_agr_id"
            ,po_agreement.SEGMENT1 as "column2" -- as "ebs_agr_no"
            ,agreement_manager.FULL_NAME as "column3" -- as "ebs_agr_manager"
            ,agreement_dept.NAME as "column4" -- as "ebs_managing_dept"
            ,agreement_agent.FULL_NAME as "column5" -- as "ebs_agr_agent"
            ,po_agreement.ATTRIBUTE5 as "column6" -- as "ebs_agr_bid_no"
            ,po_agreement.START_DATE as "column7" -- as "ebs_agr_term_start_dt"
            ,po_agreement.END_DATE as "column8" -- as "ebs_agr_term_end_dt"
            ,po_agreement.ATTRIBUTE3 as "column9" -- as "ebs_agr_doc_no"
            ,po_agreement.TYPE_LOOKUP_CODE as "column10" -- as "ebs_agr_type"
            ,po_agreement.ATTRIBUTE4 as "column11" -- as "ebs_agr_src_type"
            ,DECODE(
                po_agreement.ATTRIBUTE4,
                    'SS','Sole Source'
                    ,'FLSC','State Contract' 
                    ,'RQUAL','Request for Qualifications' 
                    ,'RFP','Request for Proposal' 
                    ,'RPS','Request for Professional Services' 
                    ,'RAT','Ratification (after-the-fact)' 
                    ,'OCC','Other Competitive Contract' 
                    ,'ITB','Invitation to Bid' 
                    ,'IGOV','Inter-governmental' 
                    ,'RFQ','Informal Quotation' 
                    ,'HCGPC','Governmental Purchasing Council' 
                    ,'FSGA','Federal Government Contract (GSA)' 
                    ,'EXPRO','Exempt from Procurement'
                    ,'EMERG','Emergency Purchase'
                    ,'DPCM','Direct Purchase of Construction Materials'
                    ,'DPUR','Direct Purchase Below Competitive Threshold (<$5,000)'
                    ,'COOP','Cooperative Purchases'
                ,'Source Description Not Found'
            ) as "column12" -- as "ebs_agr_src_descr"
            ,po_agreement.ATTRIBUTE9 as "column13" -- as "ebs_agr_renew_code"
            ,po_agreement.AUTHORIZATION_STATUS as "column14" -- as "ebs_agr_auth_status"
            ,po_agreement.APPROVED_DATE as "column15" -- as "ebs_agr_auth_dt"
            ,po_agreement.CANCEL_FLAG as "column16" -- as "ebs_agr_cncl"
            ,po_agreement.CONTERMS_EXIST_FLAG as "column17" -- as "ebs_agr_terms"
            ,po_agreement.REVISION_NUM as "column18" -- as "ebs_agr_rev_no"
            ,po_agreement.REVISED_DATE as "column19" -- as "ebs_agr_rev_dt"
            ,po_agreement.NOTE_TO_VENDOR as "column20" -- as "ebs_agr_vendor_note"
            ,po_agreement.NOTE_TO_RECEIVER as "column21" -- as "ebs_agr_receive_note"
            ,po_agreement.NOTE_TO_AUTHORIZER as "column22" -- as "ebs_agr_authorizer_note"
            ,po_agreement.COMMENTS as "column23" -- as "ebs_agr_title"
            ,nvl(po_agreement.BLANKET_TOTAL_AMOUNT,0) as "column24" -- as "ebs_agr_amt"
            ,po_agreement.VENDOR_ID as "column25" -- as "ebs_agr_vendor_id"
            ,po_agreement.VENDOR_SITE_ID as "column26" -- as "ebs_agr_vendor_site_id"
            ,po_agreement.VENDOR_CONTACT_ID as "column27" -- as "ebs_agr_vendor_contact_id"
            ,po_agreement.FROM_HEADER_ID as "column28" -- as "ebs_agr_from_header_id"
            ,case
                when po_agreement.CANCEL_FLAG = 'Y' then
                    'CANCELED'
                when po_agreement.AUTHORIZATION_STATUS <> 'APPROVED' then
                    'PENDING APPROVAL'
                when trunc(po_agreement.START_DATE) > trunc(sysdate) then
                    'PENDING START'
                when trunc(po_agreement.END_DATE) <= trunc(sysdate) then
                    'EXPIRED'
                else
                    'ACTIVE'
            end as "column29" -- as "ebs_agr_active_status"
            ,ebs_bid_header.AUCTION_HEADER_ID as "column30" -- as "ebs_agr_auc_header_id" --##NEW## 3/10/2021
            ,ebs_bid_header.BID_NUMBER as "column31" -- as "ebs_agr_bid_id" --##NEW## 3/10/2021
            ,po_doc_type.STYLE_DESCRIPTION as "column32" -- as "ebs_agr_doc_type" --##NEW## 3/19/2021            
            ,po_agreement.CREATION_DATE as "column49" -- as "ebs_agr_create_dt"
            ,po_agreement.LAST_UPDATE_DATE as "column50" -- as "ebs_agr_update_dt"
        from PO_HEADERS_ALL po_agreement
        inner join (
            select
                results."po_agreement_id"
            from (
                select
                    resultsA."po_agreement_id"
                from (
                        select
                            po_requisition_dists."column26" as "po_agreement_id"
                        from po_requisition_dists
                        where 1=1
                        and po_requisition_dists."column26" is not null
                        union all
                        select
                            ebs_po_dist."column36" as "po_agreement_id"
                        from ebs_po_dist
                        where 1=1
                        and ebs_po_dist."column36" is not null
                ) resultsA
                union all
                select
                    po_header.PO_HEADER_ID as "po_agreement_id"
                from PO_HEADERS_ALL po_header
                inner join (
                        select
                            po_requisition_dists."column26" as "join_agreement_id"
                        from po_requisition_dists
                        where 1=1
                        and po_requisition_dists."column26" is not null
                        union all
                        select
                            ebs_po_dist."column36" as "join_agreement_id"
                        from ebs_po_dist
                        where 1=1
                        and ebs_po_dist."column36" is not null
                ) resultsB
                    on(po_header.FROM_HEADER_ID = resultsB."join_agreement_id")
            ) results
            group by
                results."po_agreement_id"
        ) return_po_agreement_id
            on
                (
                    po_agreement.PO_HEADER_ID = return_po_agreement_id."po_agreement_id"
                        and
                    po_agreement.TYPE_LOOKUP_CODE = 'BLANKET' --##NEW## 3/10/2021
                )
        left join PON_AUCTION_HEADERS_ALL ebs_auction_header
            on(po_agreement.ATTRIBUTE5 = ebs_auction_header.DOCUMENT_NUMBER)
        left join PON_BID_HEADERS ebs_bid_header
            on
                (
                    ebs_auction_header.AUCTION_HEADER_ID = ebs_bid_header.AUCTION_HEADER_ID
                        and
                    po_agreement.VENDOR_ID = ebs_bid_header.VENDOR_ID
                        and
                    po_agreement.VENDOR_SITE_ID = ebs_bid_header.VENDOR_SITE_ID
                )
        left join PO_DOC_STYLE_HEADERS po_doc_type
            on(po_agreement.STYLE_ID = po_doc_type.STYLE_ID)                
        left join PER_ALL_PEOPLE_F agreement_agent
            on(
                po_agreement.AGENT_ID = agreement_agent.PERSON_ID
                    and
                trunc(sysdate)
                    between
                trunc(agreement_agent.EFFECTIVE_START_DATE)
                    and
                trunc(agreement_agent.EFFECTIVE_END_DATE)
            )
        left join PER_ALL_PEOPLE_F agreement_manager
            on(
                po_agreement.ATTRIBUTE2 = agreement_manager.PERSON_ID
                    and
                trunc(sysdate)
                    between
                trunc(agreement_manager.EFFECTIVE_START_DATE)
                    and
                trunc(agreement_manager.EFFECTIVE_END_DATE)
            )
        left join PER_ALL_ASSIGNMENTS_F per_all_assign
            on(
                agreement_manager.PERSON_ID = per_all_assign.PERSON_ID
                    and
                trunc(sysdate)
                    between
                trunc(per_all_assign.EFFECTIVE_START_DATE)
                    and
                trunc(per_all_assign.EFFECTIVE_END_DATE)
                    and
                per_all_assign.ASSIGNMENT_TYPE = 'E'
            )
        left join HR_ALL_POSITIONS_F hr_all_pos
            on(
                per_all_assign.POSITION_ID = hr_all_pos.POSITION_ID
                    and
                trunc(sysdate)
                    between
                trunc(hr_all_pos.EFFECTIVE_START_DATE)
                    and
                trunc(hr_all_pos.EFFECTIVE_END_DATE)
            )           
        left join HR_ALL_POSITIONS_F hr_all_pos
            on(
                per_all_assign.POSITION_ID = hr_all_pos.POSITION_ID
                    and
                trunc(sysdate)
                    between
                trunc(hr_all_pos.EFFECTIVE_START_DATE)
                    and
                trunc(hr_all_pos.EFFECTIVE_END_DATE)
            )
        left join HR_ALL_ORGANIZATION_UNITS agreement_dept
            on(
                hr_all_pos.ORGANIZATION_ID = agreement_dept.ORGANIZATION_ID
                    and
                trunc(sysdate)
                    between
                trunc(agreement_dept.DATE_FROM)
                    and
                trunc(nvl(agreement_dept.DATE_TO,sysdate))
            )
        where po_agreement.CANCEL_FLAG != 'Y'
        order by
            ebs_bid_header.AUCTION_HEADER_ID asc
            ,ebs_bid_header.BID_NUMBER asc
            ,po_agreement.PO_HEADER_ID asc
            ,po_agreement.VENDOR_ID asc
            ,po_agreement.VENDOR_SITE_ID asc
    )
--select * from ebs_po_agreements

select
    ROW_NUMBER() OVER(
        ORDER BY null ASC
    ) as "ROWNUM"
    ,results.*
from (    
    Select
        po_requisition_headers."ORDINAL_SORT"
        ,cast(po_requisition_headers."DATA_GROUP" as varchar2(256)) as "DATA_GROUP"
        ,cast(po_requisition_headers."DATA_SOURCE" as varchar2(256)) as "DATA_SOURCE"    
        ,cast(po_requisition_headers."column1" as varchar2(2056)) as "column1"
        ,cast(po_requisition_headers."column2" as varchar2(2056)) as "column2"
        ,cast(po_requisition_headers."column3" as varchar2(2056)) as "column3"
        ,cast(po_requisition_headers."column4" as varchar2(2056)) as "column4"
        ,cast(po_requisition_headers."column5" as varchar2(2056)) as "column5"
        ,cast(po_requisition_headers."column6" as varchar2(2056)) as "column6"
        ,cast(po_requisition_headers."column7" as varchar2(2056)) as "column7"
        ,cast(to_char(po_requisition_headers."column8",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column8"
        ,null as "column9"
        ,null as "column10"
        ,null as "column11"
        ,null as "column12"
        ,null as "column13"
        ,null as "column14"
        ,null as "column15"
        ,null as "column16"
        ,null as "column17"
        ,null as "column18"
        ,null as "column19"
        ,null as "column20"
        ,null as "column21"
        ,null as "column22"
        ,null as "column23"
        ,null as "column24"
        ,null as "column25"
        ,null as "column26"
        ,null as "column27"
        ,null as "column28"
        ,null as "column29"
        ,null as "column30"
        ,null as "column31"
        ,null as "column32"
        ,null as "column33"
        ,null as "column34"
        ,null as "column35"
        ,null as "column36"
        ,null as "column37"
        ,null as "column38"
        ,null as "column39"
        ,null as "column40"
        ,null as "column41"
        ,null as "column42"
        ,null as "column43"
        ,null as "column44"
        ,null as "column45"
        ,null as "column46"
        ,null as "column47"
        ,null as "column48"
        ,cast(to_char(po_requisition_headers."column49",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column49"
        ,cast(to_char(po_requisition_headers."column50",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column50"
    from po_requisition_headers
        union all
    Select
        po_requisition_lines."ORDINAL_SORT"
        ,cast(po_requisition_lines."DATA_GROUP" as varchar2(256)) as "DATA_GROUP"
        ,cast(po_requisition_lines."DATA_SOURCE" as varchar2(256)) as "DATA_SOURCE"    
        ,cast(po_requisition_lines."column1" as varchar2(2056)) as "column1"
        ,cast(po_requisition_lines."column2" as varchar2(2056)) as "column2"
        ,cast(po_requisition_lines."column3" as varchar2(2056)) as "column3"
        ,cast(po_requisition_lines."column4" as varchar2(2056)) as "column4"
        ,cast(po_requisition_lines."column5" as varchar2(2056)) as "column5"
        ,cast(to_char(po_requisition_lines."column6",'999999999.9999') as varchar2(2056)) as "column6"
        ,cast(to_char(po_requisition_lines."column7",'999999999.9999') as varchar2(2056)) as "column7"
        ,cast(to_char(po_requisition_lines."column8",'999999999.9999') as varchar2(2056)) as "column8"
        ,cast(to_char(po_requisition_lines."column9",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column9"
        ,cast(po_requisition_lines."column10" as varchar2(2056)) as "column10"
        ,cast(po_requisition_lines."column11" as varchar2(2056)) as "column11"
        ,cast(po_requisition_lines."column12" as varchar2(2056)) as "column12"
        ,cast(po_requisition_lines."column13" as varchar2(2056)) as "column13"
        ,cast(po_requisition_lines."column14" as varchar2(2056)) as "column14"
        ,cast(po_requisition_lines."column15" as varchar2(2056)) as "column15"
        ,cast(to_char(po_requisition_lines."column16",'999999999.9999') as varchar2(2056)) as "column16"
        ,cast(to_char(po_requisition_lines."column17",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column17"
        ,cast(po_requisition_lines."column18" as varchar2(2056)) as "column18"
        ,cast(po_requisition_lines."column19" as varchar2(2056)) as "column19"
        ,cast(po_requisition_lines."column20" as varchar2(2056)) as "column20"
        ,cast(po_requisition_lines."column21" as varchar2(2056)) as "column21"
        ,cast(po_requisition_lines."column22" as varchar2(2056)) as "column22"
        ,cast(po_requisition_lines."column23" as varchar2(2056)) as "column23"
        ,cast(po_requisition_lines."column24" as varchar2(2056)) as "column24"
        ,cast(po_requisition_lines."column25" as varchar2(2056)) as "column25"
        ,cast(po_requisition_lines."column26" as varchar2(2056)) as "column26"
        ,cast(to_char(po_requisition_lines."column27",'999999999.9999') as varchar2(2056)) as "column27"
        ,cast(po_requisition_lines."column28" as varchar2(2056)) as "column28"
        ,cast(to_char(po_requisition_lines."column29",'999999999.9999') as varchar2(2056)) as "column29"
        ,cast(po_requisition_lines."column30" as varchar2(2056)) as "column30" --##NEW## 03/13/2021
        ,cast(po_requisition_lines."column31" as varchar2(2056)) as "column31" --##NEW## 03/13/2021
        ,cast(po_requisition_lines."column32" as varchar2(2056)) as "column32" --##NEW## 03/13/2021
        ,cast(po_requisition_lines."column33" as varchar2(2056)) as "column33" --##NEW## 03/13/2021
        ,cast(po_requisition_lines."column34" as varchar2(2056)) as "column34" --##NEW## 03/13/2021
        ,cast(po_requisition_lines."column35" as varchar2(2056)) as "column35" --##NEW## 03/13/2021
        ,cast(po_requisition_lines."column36" as varchar2(2056)) as "column36" --##NEW## 03/13/2021
        ,cast(po_requisition_lines."column37" as varchar2(2056)) as "column37" --##NEW## 03/13/2021
        ,null as "column38"
        ,null as "column39"
        ,null as "column40"
        ,null as "column41"
        ,null as "column42"
        ,null as "column43"
        ,null as "column44"
        ,null as "column45"
        ,null as "column46"
        ,null as "column47"
        ,null as "column48"
        ,cast(to_char(po_requisition_lines."column49",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column49"
        ,cast(to_char(po_requisition_lines."column50",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column50"
    from po_requisition_lines
        union all
    Select
        po_requisition_dists."ORDINAL_SORT"
        ,cast(po_requisition_dists."DATA_GROUP" as varchar2(256)) as "DATA_GROUP"
        ,cast(po_requisition_dists."DATA_SOURCE" as varchar2(256)) as "DATA_SOURCE"    
        ,cast(po_requisition_dists."column1" as varchar2(2056)) as "column1"
        ,cast(po_requisition_dists."column2" as varchar2(2056)) as "column2"
        ,cast(po_requisition_dists."column3" as varchar2(2056)) as "column3"
        ,cast(po_requisition_dists."column4" as varchar2(2056)) as "column4"
        ,cast(po_requisition_dists."column5" as varchar2(2056)) as "column5"
        ,cast(po_requisition_dists."column6" as varchar2(2056)) as "column6"
        ,cast(po_requisition_dists."column7" as varchar2(2056)) as "column7"
        ,cast(po_requisition_dists."column8" as varchar2(2056)) as "column8"
        ,cast(po_requisition_dists."column9" as varchar2(2056)) as "column9"
        ,cast(po_requisition_dists."column10" as varchar2(2056)) as "column10"
        ,cast(po_requisition_dists."column11" as varchar2(2056)) as "column11"
        ,cast(po_requisition_dists."column12" as varchar2(2056)) as "column12"
        ,cast(po_requisition_dists."column13" as varchar2(2056)) as "column13"
        ,cast(po_requisition_dists."column14" as varchar2(2056)) as "column14"
        ,cast(to_char(po_requisition_dists."column15",'999999999.9999') as varchar2(2056)) as "column15"
        ,cast(to_char(po_requisition_dists."column16",'999999999.9999') as varchar2(2056)) as "column16"
        ,cast(po_requisition_dists."column17" as varchar2(2056)) as "column17"
        ,cast(po_requisition_dists."column18" as varchar2(2056)) as "column18"
        ,cast(po_requisition_dists."column19" as varchar2(2056)) as "column19"
        ,cast(po_requisition_dists."column20" as varchar2(2056)) as "column20"
        ,cast(po_requisition_dists."column21" as varchar2(2056)) as "column21"
        ,cast(to_char(po_requisition_dists."column22",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column22"
        ,cast(to_char(po_requisition_dists."column23",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column23"
        ,cast(to_char(po_requisition_dists."column24",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column24"
        ,cast(to_char(po_requisition_dists."column25",'999999999.9999') as varchar2(2056)) as "column25"
        ,cast(po_requisition_dists."column26" as varchar2(2056)) as "column26"
        ,cast(po_requisition_dists."column27" as varchar2(2056)) as "column27"
        ,cast(po_requisition_dists."column28" as varchar2(2056)) as "column28"
        ,null as "column29"
        ,null as "column30"
        ,null as "column31"
        ,null as "column32"
        ,null as "column33"
        ,null as "column34"
        ,null as "column35"
        ,null as "column36"
        ,null as "column37"
        ,null as "column38"
        ,null as "column39"
        ,null as "column40"
        ,null as "column41"
        ,null as "column42"
        ,null as "column43"
        ,null as "column44"
        ,null as "column45"
        ,null as "column46"
        ,null as "column47"
        ,null as "column48"
        ,cast(to_char(po_requisition_dists."column49",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column49"
        ,cast(to_char(po_requisition_dists."column50",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column50"
    from po_requisition_dists
        union all
    Select
        ebs_po_headers."ORDINAL_SORT"
        ,cast(ebs_po_headers."DATA_GROUP" as varchar2(256)) as "DATA_GROUP"
        ,cast(ebs_po_headers."DATA_SOURCE" as varchar2(256)) as "DATA_SOURCE"    
        ,cast(ebs_po_headers."column1" as varchar2(2056)) as "column1"
        ,cast(ebs_po_headers."column2" as varchar2(2056)) as "column2"
        ,cast(ebs_po_headers."column3" as varchar2(2056)) as "column3"
        ,cast(ebs_po_headers."column4" as varchar2(2056)) as "column4"
        ,cast(to_char(ebs_po_headers."column5",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column5"
        ,cast(ebs_po_headers."column6" as varchar2(2056)) as "column6"
        ,cast(to_char(ebs_po_headers."column7",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column7"
        ,cast(ebs_po_headers."column8" as varchar2(2056)) as "column8"
        ,cast(ebs_po_headers."column9" as varchar2(2056)) as "column9"
        ,cast(to_char(ebs_po_headers."column10",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column10"
        ,cast(ebs_po_headers."column11" as varchar2(2056)) as "column11"
        ,cast(ebs_po_headers."column12" as varchar2(2056)) as "column12"
        ,cast(ebs_po_headers."column13" as varchar2(2056)) as "column13"
        ,cast(ebs_po_headers."column14" as varchar2(2056)) as "column14" --##NEW## 03/10/2021
        ,cast(ebs_po_headers."column15" as varchar2(2056)) as "column15" --##NEW## 03/10/2021
        ,cast(ebs_po_headers."column16" as varchar2(2056)) as "column16" --##NEW## 03/10/2021
        ,cast(ebs_po_headers."column17" as varchar2(2056)) as "column17" --##NEW## 03/10/2021
        ,cast(ebs_po_headers."column18" as varchar2(2056)) as "column18" --##NEW## 03/10/2021
        ,cast(ebs_po_headers."column19" as varchar2(2056)) as "column19" --##NEW## 03/10/2021
        ,cast(ebs_po_headers."column20" as varchar2(2056)) as "column20" --##NEW## 03/10/2021
        ,cast(ebs_po_headers."column21" as varchar2(2056)) as "column21" --##NEW## 03/10/2021
        ,cast(ebs_po_headers."column22" as varchar2(2056)) as "column22" --##NEW## 03/10/2021
        ,cast(ebs_po_headers."column23" as varchar2(2056)) as "column23" --##NEW## 03/10/2021
        ,cast(ebs_po_headers."column24" as varchar2(2056)) as "column24" --##NEW## 03/10/2021
        ,cast(ebs_po_headers."column25" as varchar2(2056)) as "column25" --##NEW## 03/10/2021
        ,null as "column26"
        ,null as "column27"
        ,null as "column28"
        ,null as "column29"
        ,null as "column30"
        ,null as "column31"
        ,null as "column32"
        ,null as "column33"
        ,null as "column34"
        ,null as "column35"
        ,null as "column36"
        ,null as "column37"
        ,null as "column38"
        ,null as "column39"
        ,null as "column40"
        ,null as "column41"
        ,null as "column42"
        ,null as "column43"
        ,null as "column44"
        ,null as "column45"
        ,null as "column46"
        ,null as "column47"
        ,null as "column48"
        ,cast(to_char(ebs_po_headers."column49",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column49"
        ,cast(to_char(ebs_po_headers."column50",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column50"
    from ebs_po_headers
        union all
    Select
        ebs_po_lines."ORDINAL_SORT"
        ,cast(ebs_po_lines."DATA_GROUP" as varchar2(256)) as "DATA_GROUP"
        ,cast(ebs_po_lines."DATA_SOURCE" as varchar2(256)) as "DATA_SOURCE"    
        ,cast(ebs_po_lines."column1" as varchar2(2056)) as "column1"
        ,cast(ebs_po_lines."column2" as varchar2(2056)) as "column2"
        ,cast(ebs_po_lines."column3" as varchar2(2056)) as "column3"
        ,cast(ebs_po_lines."column4" as varchar2(2056)) as "column4"
        ,cast(ebs_po_lines."column5" as varchar2(2056)) as "column5"
        ,cast(ebs_po_lines."column6" as varchar2(2056)) as "column6"
        ,cast(ebs_po_lines."column7" as varchar2(2056)) as "column7"
        ,cast(to_char(ebs_po_lines."column8",'999999999.9999') as varchar2(2056)) as "column8"
        ,cast(ebs_po_lines."column9" as varchar2(2056)) as "column9"
        ,cast(to_char(ebs_po_lines."column10",'999999999.9999') as varchar2(2056)) as "column10"
        ,cast(to_char(ebs_po_lines."column11",'999999999.9999') as varchar2(2056)) as "column11"
        ,cast(ebs_po_lines."column12" as varchar2(2056)) as "column12"
        ,cast(to_char(ebs_po_lines."column13",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column13"
        ,cast(ebs_po_lines."column14" as varchar2(2056)) as "column14"
        ,cast(to_char(ebs_po_lines."column15",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column15"
        ,cast(ebs_po_lines."column16" as varchar2(2056)) as "column16"
        ,cast(to_char(ebs_po_lines."column17",'999999999.9999') as varchar2(2056)) as "column17"
        ,cast(ebs_po_lines."column18" as varchar2(2056)) as "column18" --##NEW## 03/10/2021
        ,cast(ebs_po_lines."column19" as varchar2(2056)) as "column19" --##NEW## 03/10/2021
        ,cast(ebs_po_lines."column20" as varchar2(2056)) as "column20" --##NEW## 03/10/2021
        ,cast(ebs_po_lines."column21" as varchar2(2056)) as "column21" --##NEW## 03/10/2021
        ,cast(ebs_po_lines."column22" as varchar2(2056)) as "column22" --##NEW## 03/13/2021
        ,cast(ebs_po_lines."column23" as varchar2(2056)) as "column23" --##NEW## 03/13/2021
        ,cast(ebs_po_lines."column24" as varchar2(2056)) as "column24" --##NEW## 03/13/2021
        ,cast(ebs_po_lines."column25" as varchar2(2056)) as "column25" --##NEW## 03/13/2021
        ,null as "column26"
        ,null as "column27"
        ,null as "column28"
        ,null as "column29"
        ,null as "column30"
        ,null as "column31"
        ,null as "column32"
        ,null as "column33"
        ,null as "column34"
        ,null as "column35"
        ,null as "column36"
        ,null as "column37"
        ,null as "column38"
        ,null as "column39"
        ,null as "column40"
        ,null as "column41"
        ,null as "column42"
        ,null as "column43"
        ,null as "column44"
        ,null as "column45"
        ,null as "column46"
        ,null as "column47"
        ,null as "column48"
        ,cast(to_char(ebs_po_lines."column49",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column49"
        ,cast(to_char(ebs_po_lines."column50",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column50"
    from ebs_po_lines
        union all
    Select
        ebs_po_dist."ORDINAL_SORT"
        ,cast(ebs_po_dist."DATA_GROUP" as varchar2(256)) as "DATA_GROUP"
        ,cast(ebs_po_dist."DATA_SOURCE" as varchar2(256)) as "DATA_SOURCE"    
        ,cast(ebs_po_dist."column1" as varchar2(2056)) as "column1"
        ,cast(ebs_po_dist."column2" as varchar2(2056)) as "column2"
        ,cast(ebs_po_dist."column3" as varchar2(2056)) as "column3"
        ,cast(ebs_po_dist."column4" as varchar2(2056)) as "column4"
        ,cast(ebs_po_dist."column5" as varchar2(2056)) as "column5"
        ,cast(ebs_po_dist."column6" as varchar2(2056)) as "column6"
        ,cast(ebs_po_dist."column7" as varchar2(2056)) as "column7"
        ,cast(ebs_po_dist."column8" as varchar2(2056)) as "column8"
        ,cast(ebs_po_dist."column9" as varchar2(2056)) as "column9"
        ,cast(ebs_po_dist."column10" as varchar2(2056)) as "column10"
        ,cast(ebs_po_dist."column11" as varchar2(2056)) as "column11"
        ,cast(ebs_po_dist."column12" as varchar2(2056)) as "column12"
        ,cast(ebs_po_dist."column13" as varchar2(2056)) as "column13"
        ,cast(ebs_po_dist."column14" as varchar2(2056)) as "column14"
        ,cast(to_char(ebs_po_dist."column15",'999999999.9999') as varchar2(2056)) as "column15"
        ,cast(to_char(ebs_po_dist."column16",'999999999.9999') as varchar2(2056)) as "column16"
        ,cast(to_char(ebs_po_dist."column17",'999999999.9999') as varchar2(2056)) as "column17"
        ,cast(to_char(ebs_po_dist."column18",'999999999.9999') as varchar2(2056)) as "column18"
        ,cast(to_char(ebs_po_dist."column19",'999999999.9999') as varchar2(2056)) as "column19"
        ,cast(to_char(ebs_po_dist."column20",'999999999.9999') as varchar2(2056)) as "column20"
        ,cast(to_char(ebs_po_dist."column21",'999999999.9999') as varchar2(2056)) as "column21"
        ,cast(to_char(ebs_po_dist."column22",'999999999.9999') as varchar2(2056)) as "column22"
        ,cast(to_char(ebs_po_dist."column23",'999999999.9999') as varchar2(2056)) as "column23"
        ,cast(to_char(ebs_po_dist."column24",'999999999.9999') as varchar2(2056)) as "column24"
        ,cast(to_char(ebs_po_dist."column25",'999999999.9999') as varchar2(2056)) as "column25"
        ,cast(to_char(ebs_po_dist."column26",'999999999.9999') as varchar2(2056)) as "column26"
        ,cast(to_char(ebs_po_dist."column27",'999999999.9999') as varchar2(2056)) as "column27"
        ,cast(to_char(ebs_po_dist."column28",'999999999.9999') as varchar2(2056)) as "column28"
        ,cast(to_char(ebs_po_dist."column29",'999999999.9999') as varchar2(2056)) as "column29"
        ,cast(ebs_po_dist."column30" as varchar2(2056)) as "column30"
        ,cast(ebs_po_dist."column31" as varchar2(2056)) as "column31"
        ,cast(ebs_po_dist."column32" as varchar2(2056)) as "column32"
        ,cast(ebs_po_dist."column33" as varchar2(2056)) as "column33"
        ,cast(ebs_po_dist."column34" as varchar2(2056)) as "column34"
        ,cast(ebs_po_dist."column35" as varchar2(2056)) as "column35"
        ,cast(ebs_po_dist."column36" as varchar2(2056)) as "column36"
        ,cast(ebs_po_dist."column37" as varchar2(2056)) as "column37"
        ,cast(ebs_po_dist."column38" as varchar2(2056)) as "column38" --##NEW## 03/10/2021
        ,cast(to_char(ebs_po_dist."column39",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column39" --##NEW## 03/10/2021
        ,null as "column40"
        ,null as "column41"
        ,null as "column42"
        ,null as "column43"
        ,null as "column44"
        ,null as "column45"
        ,null as "column46"
        ,null as "column47"
        ,null as "column48"
        ,cast(to_char(ebs_po_dist."column49",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column49"
        ,cast(to_char(ebs_po_dist."column50",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column50"
    from ebs_po_dist
        union all
    Select
        ebs_po_agreements."ORDINAL_SORT"
        ,cast(ebs_po_agreements."DATA_GROUP" as varchar2(256)) as "DATA_GROUP"
        ,cast(ebs_po_agreements."DATA_SOURCE" as varchar2(256)) as "DATA_SOURCE"    
        ,cast(ebs_po_agreements."column1" as varchar2(2056)) as "column1"
        ,cast(ebs_po_agreements."column2" as varchar2(2056)) as "column2"
        ,cast(ebs_po_agreements."column3" as varchar2(2056)) as "column3"
        ,cast(ebs_po_agreements."column4" as varchar2(2056)) as "column4"
        ,cast(ebs_po_agreements."column5" as varchar2(2056)) as "column5"
        ,cast(ebs_po_agreements."column6" as varchar2(2056)) as "column6"
        ,cast(to_char(ebs_po_agreements."column7",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column7"
        ,cast(to_char(ebs_po_agreements."column8",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column8"
        ,cast(ebs_po_agreements."column9" as varchar2(2056)) as "column9"
        ,cast(ebs_po_agreements."column10" as varchar2(2056)) as "column10"
        ,cast(ebs_po_agreements."column11" as varchar2(2056)) as "column11"
        ,cast(ebs_po_agreements."column12" as varchar2(2056)) as "column12"
        ,cast(ebs_po_agreements."column13" as varchar2(2056)) as "column13"
        ,cast(ebs_po_agreements."column14" as varchar2(2056)) as "column14"
        ,cast(to_char(ebs_po_agreements."column15",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column15"
        ,cast(ebs_po_agreements."column16" as varchar2(2056)) as "column16"
        ,cast(ebs_po_agreements."column17" as varchar2(2056)) as "column17"
        ,cast(ebs_po_agreements."column18" as varchar2(2056)) as "column18"
        ,cast(to_char(ebs_po_agreements."column19",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column19"
        ,cast(ebs_po_agreements."column20" as varchar2(2056)) as "column20"
        ,cast(ebs_po_agreements."column21" as varchar2(2056)) as "column21"
        ,cast(ebs_po_agreements."column22" as varchar2(2056)) as "column22"
        ,cast(ebs_po_agreements."column23" as varchar2(2056)) as "column23"
        ,cast(to_char(ebs_po_agreements."column24",'999999999.9999') as varchar2(2056)) as "column24"
        ,cast(ebs_po_agreements."column25" as varchar2(2056)) as "column25"
        ,cast(ebs_po_agreements."column26" as varchar2(2056)) as "column26"
        ,cast(ebs_po_agreements."column27" as varchar2(2056)) as "column27"
        ,cast(ebs_po_agreements."column28" as varchar2(2056)) as "column28"
        ,cast(ebs_po_agreements."column29" as varchar2(2056)) as "column29"
        ,cast(ebs_po_agreements."column30" as varchar2(2056)) as "column30" --##NEW## 3/10/2021
        ,cast(ebs_po_agreements."column31" as varchar2(2056)) as "column31" --##NEW## 3/10/2021
        ,cast(ebs_po_agreements."column32" as varchar2(2056)) as "column32" --##NEW## 3/10/2021
        ,null as "column33"
        ,null as "column34"
        ,null as "column35"
        ,null as "column36"
        ,null as "column37"
        ,null as "column38"
        ,null as "column39"
        ,null as "column40"
        ,null as "column41"
        ,null as "column42"
        ,null as "column43"
        ,null as "column44"
        ,null as "column45"
        ,null as "column46"
        ,null as "column47"
        ,null as "column48"
        ,cast(to_char(ebs_po_agreements."column49",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column49"
        ,cast(to_char(ebs_po_agreements."column50",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column50"
    from ebs_po_agreements
)results













