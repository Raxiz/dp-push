-module(sender).
-author('Yura Zhloba <yzh44yzh@gmail.com>').

-behavior(gen_server).

-export([start_link/1, send/2, test/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-include("logger.hrl").
-include("types.hrl").

-record(state, {
	  apns :: #apns{},
	  cert :: #cert{}
	 }).

%%% module API

start_link(Options) ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, Options, []).


-spec(send(#apns_msg{}, device_token()) -> ok).
send(#apns_msg{} = Msg, DeviceToken) ->
    gen_server:cast(?MODULE, {send, Msg, DeviceToken}),
    ok.


test() ->
    gen_server:cast(?MODULE, test).



%%% gen_server API

init({#apns{} = Apns, #cert{} = Cert}) ->
    ?INFO("~p inited with options ~p ~p ~n", [?MODULE, Apns, Cert]),
    {ok, #state{apns = Apns, cert = Cert}}.


handle_call(Any, _From, State) ->
    error_logger:error_msg("unknown call ~p in ~p ~n", [Any, ?MODULE]),
    {noreply, State}.


handle_cast({send, Msg, DeviceToken}, #state{apns = Apns, cert = Cert} = State) ->
    apns:send(Msg, DeviceToken, Apns, Cert),
    {noreply, State};

handle_cast(test, #state{apns = Apns, cert = Cert} = State) ->
    Msg = apns:test_msg(),
    DeviceToken = apns:test_device_token(),
    apns:send(Msg, DeviceToken, Apns, Cert),
    {noreply, State};

handle_cast(Any, State) ->
    error_logger:error_msg("unknown cast ~p in ~p ~n", [Any, ?MODULE]),
    {noreply, State}.


handle_info(Request, State) ->
    error_logger:error_msg("unknown info ~p in ~p ~n", [Request, ?MODULE]),
    {noreply, State}.


terminate(_Reason, _State) ->
    ok.


code_change(_OldVersion, State, _Extra) ->
    {ok, State}.	

