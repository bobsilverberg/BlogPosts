<cfparam name="attributes.bAllowModify" default="true">
<cfset Items = CartDisplay.Items />
<cfset Coupon = CartDisplay.Coupon />
<cfset FootnoteDisplay = CartDisplay.FootnoteDisplay />
<table border="0" width="540" cellspacing="2" cellpadding="2">
	<cfoutput>
	<cfif attributes.bAllowModify>
		<form action="#self#" method="post">
	</cfif>
	<tr bgcolor="##CCCCCC">
		<td class="text" align="left" width="80">#attributes.TranslationService.Translate("Code")#</td>
		<td class="text" align="left" width="220">#attributes.TranslationService.Translate("Item")#</td>
		<td class="text" align="left" width="50">#attributes.TranslationService.Translate("Qty")#</td>
		<td class="text" align="center" width="80">#attributes.TranslationService.Translate("Unit Price")#</td>
		<td class="text" align="center" width="80">#attributes.TranslationService.Translate("Item Total")#</td>
		<cfif attributes.bAllowModify><td class="text" align="center" width="60">#attributes.TranslationService.Translate("Remove")#</td></cfif>
	</tr>	
	<cfloop from="1" to="#ArrayLen(Items)#" index="i">
		<cfset Item = Items[i] />
		<tr <cfif i MOD 2 NEQ 0>bgcolor="##F0F0F0"</cfif>>
			<td class="text" width="80">
				<a class="smallheadlink" href="#myself##xfa.onDetails#&ProductId=#Item.ProductId#">
					#Item.ProductCode#
				</a>
			</td> 
			<td class="text" width="220">
				<a class="smallheadlink" href="#myself##xfa.onDetails#&ProductId=#Item.ProductId#">
					#Item.theName#<cfif Len(Item.theOptions) AND Item.theOptions NEQ "n/a">&nbsp;&nbsp;(#Item.theOptions#)</cfif>
				</a>
				<cfif Len(Item.FootnoteList)>
					<a class="smallheadlink" href="##DiscountFootnotes" class="discount_footnote">
						<sup>#Item.FootnoteList#</sup>
					</a>
				</cfif>
			</td> 
			<td class="text" width="50" align="center">
				<cfif attributes.bAllowModify>
					<input name="Quantity_#Item.ItemKey#" type="Text" size="3" maxlength="6" value="#Item.Quantity#">
				<cfelse>
					#Item.Quantity#
				</cfif>
			</td>  
			<td class="text" width="80" align="right">#LSCurrencyFormat(Item.thePrice)#</td> 
			<td class="text" width="80" align="right">#LSCurrencyFormat(Item.ItemTotal)#</td>
			<cfif attributes.bAllowModify><td class="text" width="60" align="center">
				<a href="#myself##XFA.onRemove#&ItemKey=#Item.ItemKey#">
				<img border="0" src="#request.sImageRoot#btn_delete.gif" alt="#attributes.TranslationService.Translate('Remove Item')#"></a>
			</td></cfif>
		</tr>
	</cfloop>
	<tr bgcolor="##CCCCCC">

		<td class="text" align="right" colspan="4">#attributes.TranslationService.Translate("Subtotal")#</td>
		<td class="text" align="right">#LSCurrencyFormat(CartDisplay.Subtotal)#</td>
		<cfif attributes.bAllowModify><td class="text">&nbsp;</td></cfif>
	</tr>
	<cfif Val(CartDisplay.DiscountTotal)>
		<tr bgcolor="##CCCCCC">
			
			<td class="text" align="right" colspan="4">#attributes.TranslationService.Translate("Discount")#</td>
			<td class="text" align="right">#LSCurrencyFormat(CartDisplay.DiscountTotal)#</td>
			<cfif attributes.bAllowModify><td class="text">&nbsp;</td></cfif>
		</tr>
		<tr bgcolor="##CCCCCC">

			<td class="text" align="right" colspan="4">#attributes.TranslationService.Translate("Subtotal")#</td>
			<td class="text" align="right">#LSCurrencyFormat(CartDisplay.Subtotal - CartDisplay.DiscountTotal)#</td>
			<cfif attributes.bAllowModify><td class="text">&nbsp;</td></cfif>
		</tr>
	</cfif>
	<cfif NOT attributes.bAllowModify>
		<cfif Val(CartDisplay.ShippingTotal)>
			<tr>
				<td class="text" colspan="2">&nbsp;</td>
				<td class="text" colspan="2" bgcolor="##F0F0F0">#attributes.TranslationService.Translate("Shipping")#</td>
				<td class="text" align="right" bgcolor="##F0F0F0">#LSCurrencyFormat(CartDisplay.ShippingTotal)#</td>
			</tr>
		</cfif>
		<cfif Val(CartDisplay.PST)>
			<tr>
				<td class="text" colspan="2">&nbsp;</td>
				<td class="text" colspan="2">PST</td>
				<td class="text" align="right">#LSCurrencyFormat(CartDisplay.PST)#</td>
			</tr>
		</cfif>
		<cfif Val(CartDisplay.GST)>
			<tr>
				<td class="text" colspan="2">&nbsp;</td>
				<td class="text" colspan="2">GST</td>
				<td class="text" align="right">#LSCurrencyFormat(CartDisplay.GST)#</td>
			</tr>
		</cfif>
		<tr>
			<td class="text" colspan="2">&nbsp;</td>
			<td class="text" colspan="2" bgcolor="##CCCCCC">Total</td>
			<td class="text" align="right" bgcolor="##CCCCCC">#LSCurrencyFormat(CartDisplay.OrderTotal)#</td>
		</tr>
		
<cfelse>
	

<tr align="center">
			<td class="text" colspan="6"><P>
			Don't forget <a class="smallheadlink" href="#myself#Catalog.show&sPage=CardsAndWrap">#attributes.TranslationService.Translate("Gift Wrap")#</a>  and
			
					<a class="smallheadlink" href="#myself#Catalog.show&sPage=BatteryVibrators_Batteries">#attributes.TranslationService.Translate("Batteries")#</a>!
				</td>
			</tr>	

		
		<input type="Hidden" name="FA" value="#XFA.onUpdate#">		

		<cfif myFusebox.originalFuseaction EQ "checkout">
			
			<tr align="center">
				<td class="text" colspan="6">
					<br>
					<span class="test">
						#attributes.TranslationService.Translate("Checkout using Come As You Are's secure server")#.
						<br />
						#attributes.TranslationService.Translate("Click checkout to begin")#.
					</span>
				</td>
			</tr>
		</cfif>
		<tr><td class="text" colspan="6" align="center">
<input type="submit" class="order" value="#attributes.TranslationService.Translate('Update Cart')#"> 


<a href="#myself##XFA.onContinue#">
<input type="submit" class="order" value="#attributes.TranslationService.Translate('Secure Checkout')#"></a>
			
			<P>
			
			<a class="smallheadlink" href="#myself##XFA.onShopMore#">#attributes.TranslationService.Translate('Continue Shopping')#</a>
	
		
			<br><br>
		</td></tr>
		</form>
		
<!--- Coupon Code Entry --->
	<tr align="center">
		<td class="text" colspan="6">
			
			<form name="frmCoupon" id="frmCoupon" action="#myself##XFA.onCoupon#" method="post">
				<input type="hidden" name="ReturnFA" id="ReturnFA" value="#myFusebox.originalCircuit#.#myFusebox.originalFuseaction#" />

#attributes.TranslationService.Translate("Have a coupon?  Enter it here")#: <input type="text" name="CouponCode" id="CouponCode" />
				<input type="submit" class="order" value="Apply Coupon" />
		
			<cfif IsDefined("attributes.CouponMsg") AND Len(attributes.CouponMsg)>
				<p>#attributes.CouponMsg#</p>
			</cfif>
			<cfif NOT StructIsEmpty(Coupon)>
				<cfset CouponTO = attributes.Cart.getCouponTO() />
				<p>A coupon (#Coupon.CouponCode#) for "#Coupon.PromoName#" is currently being applied to your order.  You may replace this coupon by entering a different coupon code above.</p>
				<a href="#myself##XFA.onRemoveCoupon#&ReturnFA=#myFusebox.originalCircuit#.#myFusebox.originalFuseaction#">Remove this Coupon</a>
			</cfif>
			</form>
			<P>
		</td>
	</tr>
	</cfif>
	
	<!--- Display the discount footnotes --->
	<!--- Are there any? --->
	<!--- TODO: Change this to use pre-configured footnotelist --->
	<cfif Val(CartDisplay.FootnoteNumber)>
		<tr>
			<td class="text" colspan="6">
				Discounts applied to this order:
			</td>
		</tr>
		<!--- Loop through the footnotes --->
		<cfloop collection="#FootnoteDisplay#" item="fn">
			<tr>
				<td class="text" colspan="6">
					#FootnoteDisplay[fn].FootnoteText#
				</td>
			</tr>
		</cfloop>
	</cfif>
</table>
<br>
</cfoutput>

