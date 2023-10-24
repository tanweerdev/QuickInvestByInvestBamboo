# QuickInvest
 
 Abstract Design of System
 ==========================

 Source: 
        The source shall produce `events` of new company listing and inform our system, we're assuming for now that the
        events shall be published in real-time

 Source Subrscriber:
        A GenServer, which shall listens to the source. Here we mock the incomming events. The `Source Subscriber` pushes all the recieved events to `Queue`

 Queue:
        A GenServer, which behaves as a FIFO queue. One of the purpose of this Queue is to handle back-pressure.

 Consumer: 
        A GenServer which consumes a single event from the Queue and processes it. We can have any number of Consumer, this number is specified in `config.exs`.
 
 ```
                                                                             ┌────────────┐
                                                                  ┌────────► │  Consumer  │
                                                                  │          └────────────┘
 (3rd Party)                                                      │
┌───────────┐      ┌──────────────────────┐     ┌────────────┐    │          ┌────────────┐
│  Source   ├─────►│  Source Subscriber   ├────►│  Queue     ├────┼────────► │  Consumer  │
└───────────┘      └──────────────────────┘     └────────────┘    │          └────────────┘
                                                                  │
                                                                  │         ┌────────────┐
                                                                  └───────► │  Consumer  │
                                                                            └────────────┘
```
