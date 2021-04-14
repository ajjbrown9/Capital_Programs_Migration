--======================================================================================
-- INVOICE HEADER STATUS CASE EXAMPLE
--======================================================================================
CASE
    WHEN
        ap_inv_header.cancelled_date IS NOT NULL
    THEN
        CASE
            WHEN
                ap_inv_header.cancelled_amount = ap_inv_header.approved_amount
            THEN 'CANCELED'
            WHEN
                NVL(ap_inv_header.cancelled_amount,0) != 0
                    AND
                NVL(ap_inv_header.cancelled_amount,0) != nvl(ap_inv_header.approved_amount,0)
            THEN 'PARTIAL CANCELATION'
            WHEN
                NVL(ap_inv_header.cancelled_amount,0) = 0
            THEN 'REVIEW REQUIRED' -- The business needs to look at these examples to confirm. 2447383 is also a special case
        END
    ELSE 'ACTIVE'
END AS "AP_INV_HEADER_STATUS"

--======================================================================================
-- INVOICE PAYMENT STATUS CASE EXAMPLE
--======================================================================================
        
CASE
    WHEN
        ap_inv_check.cleared_date IS NULL
            AND
        ap_inv_payment.reversal_flag = 'Y'
    THEN 'REVERSED' -- the line amounts show as cancelling each other out without fail.
    WHEN
        (
        ap_inv_payment.reversal_flag IS NULL
            OR
        ap_inv_payment.reversal_flag = 'N' -- seems to be that N or blank has no cancellation
        )
            AND
        ap_inv_check.cleared_date IS NULL -- cleared date doesnt seem to make a difference between cleared / pending
    THEN 'PENDING'
    ELSE 'CLEARED'
END AS "AP_INV_CHECK_STATUS"
        