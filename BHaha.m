classdef BHaha < handle
    
    properties(Constant)
        cMem = 1;
    end
    
    properties
        mMem;
    end
    
    methods
        function obj = BHaha(input_)
            obj.mMem = input_;
        end
        function rtn = MyAdd(obj, input_)
            rtn = obj.mMem + input_;
        end
    end
    
    methods (Static)
        function ret = SMyAdd(x, y)
            ret = x + y;
        end
    end
    
end