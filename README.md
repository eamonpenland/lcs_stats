# LcsStats

This is an application meant to read from a websocket and write the result to an elasticsearch cluster.

The initial intent of this library was to capture content from League of Legends statistics broadcasts and store them for immediate and delayed usage. Ultimately I want to provide a better and/or second screen statistics experience for viewers. I also want to provide a streaming stats display for delayed viewers. Vods are posted for viewing after Riot's video streams finish. I have always wanted to see the stats provided along with these vods.

The application was up and running on Digital Ocean for about 6 months where I collected 500k stat points for ~300 games of League of Legends.

My goal was to learn Elixir and its OTP stack. I am new to process based programming and the use case was perfect for the concepts.

With that said, I have quite a long ways to go. There are some things I still don't grok including simple-one-for-one and building multi-level supervision trees. Everything here is on a single static level.

I did end up having to make a significant conversion as I updated Elixir versions. I moved from the deprecated, non-process-based GenEvent to the newer, more powerful, and flexible GenStage. I have been impressed with GenStage and its capabilities. I'm happy the core team decided to make the switch.

All in all this is largely a work in progress that I never really meant to see the light of day. However I think it's a good project to show others. It is a relatively approachable size for an introduction to some concepts.

I may revisit this project some day and make the websocket readers actually fault tolerant. I would also love to dynamically scrape and manage the web socket addresses from lolesports.com as they are created. Lastly I will need to create and store point-in-stream snapshots of the entire game state to enable effective point-in-time replaying of the stats. This last piece is basically just another subscriber in the GenStage pipeline.

From there I will create a web socket that will re-publish these statistics on demand. The frames will be consumed by a custom front end to provide more robust statistics about the games.

I've moved on to learning some other things, so it might be a while before I revisit this.
