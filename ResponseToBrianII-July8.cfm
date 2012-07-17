Brian and I discussed this offline, as that seemed more logical than trying to conduct a two way conversation via blog posts and comments.  Here's a summary of my thoughts after speaking to Brian:</p>

1. It makes sense to move much of the logic out of my service and into a corresponding gateway.  This will allow me to decouple my service from Transfer.

2. The current Get() method in the AbstractService can be moved into a BusinessObjectFactory, again decoupling the service from Transfer.

3. Remove the TransferClassName and EntityDesc from Coldspring and just hardcode them into the constructor of the Concrete Service Objects.  As the values are not likely to ever have to change, there's really no reason to have them managed by Coldspring.

4. I'm going to keep my method names.  I'll stick with Get() instead of moving to getReview() and getProduct().  It means less to maintain and less to change if the API to Get() ever changes.

5. Regarding the question of why TQL, I did some up with an additional idea of a benefit:

If you use TQL you can actually query your object model. So if you build your object model first, and then simply come up with a db that will support it, and use an ORM as the middle man, then you could, theoretically change the structure of the db any way you want but your code could stay the same. It's like abstracting your db schema right out of the app.  I'm not sure that I'd ever benefit from this, but it _is_ a theoretical benefit.

I don't think I'm going to implement any of these changes immediately.  I'd rather get through the series first, and then go back and refactor based on all of the feedback that I get, and then maybe there will be a follow-up series.

