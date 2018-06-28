


mro[K1] = [K1] + merge(mro(A), mro(B), [A, B])
             =  [K1] + merge([A,O], [B, O], [A, B])
             =  [K1, A] + merge([O], [B, O], [B])
             =  [K1, A, B] + merge([O], [O])
             =  [K1, A, B, O]

mro[K2] = [K2] + merge(mro(A), mro(C), [A, C])
             =  [K2] + merge([A,O], [C, O], [A, C])
             =  [K2, A] + merge([O], [C, O], [C])
             =  [K2, A, C] + merge([O], [O])
             =  [K2, A, C, O]
 

mro[Z] = [Z]  + merge(mro[K1], mro[K2], [K1, K2])
           = [Z] + merge([K1, A, B, O], [K2, A, C, O], [K1, K2])
           = [Z, K1] + merge([A, B, O], [K2, A, C, O], [K2])
           = [Z, K1, A] + merge([B, O], [K2, C, O], [K2])
           = [Z, K1, A, K2] + merge([B, O], [C, O])    
           = [Z, K1, A, K2, B] +merge([O], [C, O])
           = [Z, K1, A, K2, B, C] + merge([O], [O])
           = [Z, K1, A, K2, B, C, O]
