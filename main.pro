implement main
    open core, file, stdio

domains
    accessory_type = cpu; motherboard; ram; storage; graphics_card; display; keyboard; mouse.
    brand_name = intel; amd; asus; gigabyte; samsung; dell; logitech; microsoft; nvidia; corsair.

class facts - computerdb
    accessory : (integer AccessoryID, string AccessoryName, accessory_type AccessoryType, brand_name Brand, string ManufactureDate).
    connection_interface : (integer AccessoryID, string Interface).
    connection_slot : (integer AccessoryID, string Slot).
    product : (integer AccessoryID, integer Price).
    compatibility : (integer AccessoryID1, integer AccessoryID2).

class predicates
    calculate_total_cost : (integer* Accessories, integer TotalCost) nondeterm anyflow.
    count_accessories : (accessory_type AccessoryType, integer Count) nondeterm anyflow.
    count_list : (integer* Accessories, integer Count) nondeterm anyflow.
    are_compatible_single : (integer AccessoryID1, integer AccessoryID2) nondeterm anyflow.

clauses
    count_accessories(AccessoryType, Count) :-
        Accessories = [ AccessoryID || accessory(AccessoryID, _, AccessoryType, _, _) ],
        count_list(Accessories, Count).

    count_list([], 0).
    count_list([_ | T], N) :-
        count_list(T, N1),
        N = N1 + 1.

    calculate_total_cost([], 0) :-
        !.

    calculate_total_cost([AccessoryID | Rest], TotalCost) :-
        product(AccessoryID, Price),
        calculate_total_cost(Rest, RemainingCost),
        TotalCost = Price + RemainingCost.

    are_compatible_single(AccessoryID1, AccessoryID2) :-
        if compatibility(AccessoryID1, AccessoryID2) then
            write("Given accessories are compatible\n")
        else
            write("Give accessoies are incompatible\n")
        end if.

%can_build_pc(Accessories) :-
%all_accessories_compatible(Accessories),
%write("PC can be built from the given accessories.\n").
%can_build_pc(_) :-
%write("PC cannot be built from the given accessories.\n").
%are_accessories_compatible(AccessoryID1, AccessoryID2) :-
%compatibility(AccessoryID1, AccessoryID2).
clauses
    run() :-
        console::init(),
        file::consult("../computerdb.txt", computerdb),
        % Example queries:
        count_accessories(cpu, CPUCount),
        write("Number of CPUs available: ", CPUCount, "\n"),
        count_accessories(ram, RAMCount),
        write("Number of RAM modules available: ", RAMCount, "\n"),
        nl,
        calculate_total_cost([1, 2, 3, 4], TotalCost),
        write("Total cost of PC from given accessories: ", TotalCost, "\n"),
        are_compatible_single(1, 3),
        %can_build_pc([1, 3, 4]),
        %write("1 and 2 are: ", , "\n"),
        fail.

    run() :-
        succeed.

end implement main

goal
    console::run(main::run).
