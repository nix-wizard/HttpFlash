package network.nixwiz.engine {
    /** Pale imitation of the <code>Promise</code> class from ES6. */
    public class Promise {
        private var state:String = 'pending';
        private var value:* = undefined;
        private var reason:* = undefined;
        private var onFulfilledCallbacks:Vector.<Function> = new <Function>[];
        private var onRejectedCallbacks:Vector.<Function> = new <Function>[];

        function Promise(executor:Function) {
            var resolve:Function = function(value_:*):void {
                if (state !== 'pending') return;
                state = 'fulfilled';
                value = value_;
                for each (var cb:Function in onFulfilledCallbacks) {
                    cb(value);
                }
            };

            var reject:Function = function(reason_:*):void {
                if (state !== 'pending') return;
                state = 'rejected';
                reason = reason_;
                for each (var cb:Function in onRejectedCallbacks) {
                    cb(reason);
                }
            };

            try {
                executor(resolve, reject);
            }
            catch (error:*) {
                reject(error);
            }
        }

        public function then(onFulfilled:Function = null, onRejected:Function = null):Promise {
            if (onFulfilled == null) {
                onFulfilled = function(value:*):* { return value; }
            }
            if (onRejected == null) {
                onRejected = function(reason:*):void { throw reason; }
            }

            return new Promise(function(resolve:Function, reject:Function):void {
                function createHandler(fn:Function):Function {
                    return function():void {
                        try {
                            var result:* = fn(value);
                            if (result is Promise) {
                                (result as Promise).then(resolve, reject);
                            }
                            else {
                                resolve(result);
                            }
                        }
                        catch (error:*) {
                            reject(error);
                            Logger.log('Possibly uncaught error in promise: ' + error);
                        }
                    };
                }

                var handleFulfilled:Function = createHandler(onFulfilled);
                var handleRejected:Function = createHandler(onRejected);

                if (state === 'fulfilled') { handleFulfilled(); }
                else if (state === 'rejected') { handleRejected(); }
                else {
                    onFulfilledCallbacks.push(handleFulfilled);
                    onRejectedCallbacks.push(handleRejected);
                }
            });
        }

        /** Equivalent of JS <code>.catch()</code>. */
        public function fail(onRejected:Function):Promise {
            return then(null, onRejected);
        }

        /** @return A promise that immediately resolves to <code>value</code>. */
        public static function resolve(value:* = undefined):Promise {
            return new Promise(function(resolve:Function, _:*):void {
                resolve(value);
            });
        }
    }
}