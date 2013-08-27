/**
 * Created with IntelliJ IDEA.
 * User: WORKSATION
 * Date: 4/17/13
 * Time: 10:19 PM
 * To change this template use File | Settings | File Templates.
 */
package com.chaoslabgames.commons.fms {
import flash.events.Event;

import org.flexunit.asserts.assertFalse;
import org.flexunit.asserts.assertTrue;
import org.hamcrest.assertThat;
import org.hamcrest.core.throws;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.sameInstance;

public class FMSTest {

    var fms:FiniteStateMachine = new FiniteStateMachine();

    [Test]
    public function testTransition() {
        //given
        fms.state("B")
        fms.state("A").addTransition("custom_type").toState("B");
        fms.changeState("A");
        assertThat(fms.currentState, equalTo(fms.state("A")));
        //when
        fms.handleEvent(new Event("custom_type"));
        //then
        assertThat(fms.currentState, equalTo(fms.state("B")));
    }

    [Test]
    public function testDeterminate() {
        try {
            assertThat(fms.state("A"), sameInstance(fms.state("A")))
            assertThat(fms.state("A").addTransition("T"), sameInstance(fms.state("A").addTransition("T")))
            throw new Error("transition must be refused")
        } catch (e:Error) {
            if (e.message != "There is another transition for 'T'") {
                throw e;
            }
        }
    }

    [Test]
    public function testHandler() {
        //given
        var handledEvent:Event;
        var expectedEvent:Event = new Event("event_type");
        fms.state("A").addHandler("event_type", function (e:Event):void {
            handledEvent = e;
        });
        fms.changeState("A")
        //when
        fms.handleEvent(expectedEvent)
        //then
        assertThat(expectedEvent, equalTo(handledEvent));
    }

    [Test]
    public function testStartStateIsFirstStateByDefault():void {
        //given
        fms.state("A");
        //then
        assertThat(fms.currentState.name, equalTo("A"));
    }

    [Test]
    public function testHandlersWithTheSameType() {
        //given
        var firstProcessed:Boolean
        var secondProcessed:Boolean
        fms.state("A")
                .addHandler("event_type", function ():void {
                    firstProcessed = true;
                })
                .addHandler("event_type", function ():void {
                    secondProcessed = true
                })
        //when
        fms.handleEvent(new Event("event_type"))
        //then
        assertTrue(firstProcessed)
        assertTrue(secondProcessed)
    }

    [Test]
    public function testActivateStateHandler():void {
        //given
        var processed:Boolean = false;
        fms.state("A").addActivateHandler(function ():void { processed = true });

        //when
        fms.start()
        //then
        assertTrue(processed)
    }


    [Test]
    public function testDeactivateStateHandler():void {
        //given
        var processed:Boolean = false;
        fms.state("A").addDeactivateHandler(function ():void { processed = true });
        fms.state("B")

        //when
        fms.changeState("A")
        fms.changeState("B")
        //then
        assertTrue(processed)
    }

    [Test]
    public function testConditionalTransitions():void {
        //given
        fms.state("A")
                .addTransition("event_type", "invFalse")
                        .addConditional(isFalse)
                        .toState("B")._from
                .addTransition("event_type", "invTrue")
                        .addConditional(isTrue)
                        .toState("C")
        fms.state("B")
        fms.state("C")

        function isTrue():Boolean {
            return true;
        }
        function isFalse():Boolean {
            return false;
        }

        //when
        fms.handleEvent({type:"event_type"});

        //then
        assertThat(fms.currentState.name, equalTo("C"))
    }
}
}
