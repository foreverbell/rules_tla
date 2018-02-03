------------------------------- MODULE hourclock -------------------------------
EXTENDS Naturals

VARIABLE hr

Init == hr \in (1 .. 12)
Next == hr' = IF hr # 12 THEN hr + 1 ELSE 1

Spec == Init /\ [][Next]_hr

Invariant == hr \in (2 .. 12)
--------------------------------------------------------------------------------

THEOREM Spec => []Invariant
================================================================================
