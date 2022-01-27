window_width=1300
window_height=800
Class = require "class"
Paddle= Class{}
state="menu"
score_p1=0
score_p2=0
math.randomseed(os.time())
function Paddle:init(x,y,width,height)
    self.x=x
    self.y=y
    self.width=width
    self.height=height
    self.speed=200
end
Ball= Class{}
function Ball:init(x,y,width,height)
    self.x=x
    self.y=y
    self.width=width
    self.height=height
    self.xspeed=300
    self.yspeed=300
end
initial_x=window_width/2-5
initial_y=window_height/2-5
function Ball:update(dt)
    self.x=self.x+self.xspeed*dt
    self.y=self.y+self.yspeed*dt
    if(self.y>window_height-self.height)then
        self.yspeed=-self.yspeed
        self.y=window_height-self.height
        r1=math.random(1,4)------miss or not
        r2=math.random(10,25)------ number of pixels missed by the paddle
        r3=math.random(0,2)---------- ahead or behind
    end
    if(self.y<0)then
        self.yspeed=-self.yspeed
        self.y=0
    end
    if (collision(ball,left_paddle))then
        ball.xspeed=-ball.xspeed
        ball.x=left_paddle.width
        r1=math.random(1,4)------miss or not
        r2=math.random(10,25)------ number of pixels missed by the paddle
        r3=math.random(0,2)---------- ahead or behind    
    end
    if (collision(ball,right_paddle))then
        ball.xspeed=-ball.xspeed
        ball.x=window_width-right_paddle.width-ball.width
        
    end
  

end
function Ball:score()
    if(self.x>window_width) then
        score_p1=score_p1+1
        self.x=initial_x
        self.y=initial_y
        AIplayer()
    end
    if(self.x<0) then
        score_p2=score_p2+1
        self.x=initial_x
        self.y=initial_y
        AIplayer()
    end
end
function collision(v,k)
    return v.x<k.x+k.width and
           v.x+v.width>k.x and
           v.y<k.y+k.height and
           v.y+v.height>k.y
end
function AIplayer()
    
    if(r1>=1 and r1<=3)then
        right_paddle.y=ball.y-right_paddle.height/2
    elseif(r1==4)then
        if(r3<=1)then
            right_paddle.y=ball.y+r2
        elseif(r3>1 and r3<=2)then
            right_paddle.y=ball.y-right_paddle.height-r2
        end
    end
end



left_paddle=Paddle(0,window_width/2-100/2,20,100)
right_paddle=Paddle(window_width-20,window_width/2-100/2,20,100)
ball=Ball(window_width/2,window_height/2,10,10)
function love.load()
    love.window.setMode(window_width,window_height)
    main_bg=love.graphics.newImage('main_bg.png')
    r1=math.random(1,4)------miss or not
    r2=math.random(10,25)------ number of pixels missed by the paddle
    r3=math.random(0,2)---------- ahead or behind
end
function love.update(dt)
    if(state=="play")then
        if(love.keyboard.isDown('w')) then
            left_paddle.y=math.max(0,left_paddle.y-left_paddle.speed*dt)
        end
        if(love.keyboard.isDown('s')) then
            left_paddle.y=math.min(left_paddle.y+left_paddle.speed*dt,window_height-left_paddle.height)
        end
        ball:update(dt)
        ball:score()
        AIplayer()
        
    end
end
function love.keypressed(key)


    if(state=="menu" and key=="return")then
      state="play"
    end
    if(state=="play" and key=="escape") then
        state="end"
    end

    if (state=="end" and key == "return") then
      state="menu"
    end 
    if (state=="end" and key == "escape") then
        love.event.quit()
    end 

end
function love.draw()
    if(state=="menu") then
        love.graphics.draw(main_bg,0,0,0,window_width/main_bg:getWidth(),window_height/main_bg:getHeight())
        love.graphics.print("Press enter to play ",450,500,0,3,3)
        love.graphics.print("Press esc to exit",500,600,0,3,3)
    elseif(state=="end")then
        love.graphics.print(score_p1.."     SCORE     "..score_p2,650,400,0,4,4)
        love.graphics.print("Press enter to play again",450,500,0,3,3)
        love.graphics.print("Press esc to exit",500,600,0,3,3)
    else
        love.graphics.setColor(1,0,0)
        love.graphics.rectangle("fill",left_paddle.x,left_paddle.y,left_paddle.width,left_paddle.height)
        love.graphics.setColor(0,0,1)
        love.graphics.rectangle("fill",right_paddle.x,right_paddle.y,right_paddle.width,right_paddle.height)
        love.graphics.setColor(255,255,255)
        love.graphics.circle("fill",ball.x,ball.y,5)
        love.graphics.print(score_p1.."     SCORE     "..score_p2,window_width/2-100,0,0,3,3)

    end
    
end